# Reactorkit 테스트

![image](https://github.com/leojini/TestReactorkit/assets/17540345/ccb3910e-97a6-4554-b958-3351b02bde1e)


![image](https://github.com/leojini/TestReactorkit/assets/17540345/d946afdd-c611-4c8f-b81b-3cf52ba28677)


1. 언어: Swift
2. 기본 개념: 사용자 Action 발생시 mutate -> reduce 를 통해 State를 반환한다.
3. mutate: Action을 파라미터로 입력받아 Observable < Mutation > 을 반환한다.
   ```
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
   ![image](https://github.com/leojini/TestReactorkit/assets/17540345/4bc9f9df-100d-4502-8f5a-84a091cfccb8)

- increase 버튼: Action.increase를 reactor에 전달한다.
  ![image](https://github.com/leojini/TestReactorkit/assets/17540345/a24e2afe-6c06-43c7-b9e9-969836a3e313)

- decrease 버튼: Action.decrease를 reactor에 전달한다.
  ![image](https://github.com/leojini/TestReactorkit/assets/17540345/1ab28f43-3641-43e3-8a98-033dc1629dad)

- reactor의 value 상태 변경시 valueLabel에 설정한다.
  ![image](https://github.com/leojini/TestReactorkit/assets/17540345/7252e3e0-bd0e-4b82-aca3-3b77d49740a1)

- reactor의 isLoading 상태 변경시 activityIndicatorView의 애니메이션 설정한다.
  ![image](https://github.com/leojini/TestReactorkit/assets/17540345/69a2dce5-c6f7-4b40-8bef-a4d50625f2d4)

- reactor의 alertMessage인 경우 pulse를 사용하여 값이 새롭게 할당되는 경우에 항상 이벤트를 발생시킨다.
  상태 변경이 아니라 항상 새롭게 이벤트를 발생시켜야 할 경우에는 pulse를 사용한다.
  ![image](https://github.com/leojini/TestReactorkit/assets/17540345/823978e2-52fa-4fb2-922c-0b0baff6bbe7)
  ![image](https://github.com/leojini/TestReactorkit/assets/17540345/7ad685a8-6a3f-4ca7-87c8-5b82d3af0faf)

- 유닛 테스트 코드 추가
  ![image](https://github.com/leojini/TestReactorkit/assets/17540345/55355630-f852-4bf0-bb4f-3157fa219fac)
  ![image](https://github.com/leojini/TestReactorkit/assets/17540345/08e21b21-e9c4-4e35-8a8f-b1b2c0e17466)


