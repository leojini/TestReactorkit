# Reactorkit 테스트

![image](https://github.com/leojini/TestReactorkit/assets/17540345/ccb3910e-97a6-4554-b958-3351b02bde1e)


![image](https://github.com/leojini/TestReactorkit/assets/17540345/d946afdd-c611-4c8f-b81b-3cf52ba28677)


1. 언어: Swift
2. 기본 개념: 사용자 Action 발생시 mutate -> reduce 를 통해 State를 반환한다.
3. mutate: Action을 파라미터로 입력받아 Observable < Mutation > 을 반환한다.
   ```swift
   func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.milliseconds(2000), scheduler: MainScheduler.instance),
                // Observable.just(Mutation.increaseValue),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertMessage("increased!")),
            ])
            
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.milliseconds(2000), scheduler: MainScheduler.instance),
                // Observable.just(Mutation.decreaseValue),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertMessage("descreased!")),
            ])
        }
    }
   ```

5. reduce: State, Mutation을 입력받아 State의 내부값 변경 후 State를 반환한다.
   ```swift
   func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .increaseValue:
            state.value += 1
            
        case .decreaseValue:
            state.value -= 1
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .setAlertMessage(message):
            state.alertMessage = message
        }
        return state
    }
   ```

- increase 버튼: Action.increase를 reactor에 전달한다.
  ```swift
   increseButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
  ```

- decrease 버튼: Action.decrease를 reactor에 전달한다.
  ```swift
   decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
  ```

- reactor의 value 상태 변경시 valueLabel에 설정한다.
  ```swift
   reactor.state.map { $0.value }
            .distinctUntilChanged()
            .map { "\($0)"}
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
  ```

- reactor의 isLoading 상태 변경시 activityIndicatorView의 애니메이션 설정한다.
  ```swift
   reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
  ```

- reactor의 alertMessage인 경우 pulse를 사용하여 값이 새롭게 할당되는 경우에 항상 이벤트를 발생시킨다.
  상태 변경이 아니라 항상 새롭게 이벤트를 발생시켜야 할 경우에는 pulse를 사용한다.
  ```swift
  struct State {
     var value: Int
     var isLoading: Bool
     @Pulse var alertMessage: String?
    }
  
   reactor.pulse(\.$alertMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                let alertController = UIAlertController(
                    title: nil,
                    message: message,
                    preferredStyle: .alert
                    )
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                ))
                self?.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)

  
  ```

- 유닛 테스트 코드 추가
  ```swift
   func testReactor() throws {
        let reactor = ViewReactor()
        reactor.action.onNext(.increase)
        
        // increase 액션이 2초 지연되므로 2초 후 값 체크하는 로직 추가
        let expectation = XCTestExpectation(description: "aaa")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(reactor.currentState.value, 1)
    }

  func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // decrease 버튼
        let button = app.buttons["-"]
        XCTAssertTrue(button.exists)
        button.tap()

        
        // decrease 버튼이 2초 지연되므로 2초 지연 로직 추가
        let expectation = expectation(description: "labelExp")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        
        // decrease 버튼 이 후 값이 -1됐는지 여부 테스트
        let label = app.staticTexts.element(matching: .any, identifier: "-1")
        XCTAssertTrue(label.exists)
    }
  ```


