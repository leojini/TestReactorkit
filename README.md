
Reactorkit 테스트

1. 기본 개념: 유저 action 발생시 mutate -> reduce 를 통해 state를 반환
2. mutate: Action을 파라미터로 입력받아 Observable Mutation 을 반환
3. reduce: State, Mutation을 입력받아 State의 내부값 변경 후 State를 반환

- increase 버튼: Action.increase를 reactor에 전달한다.
- decrease 버튼: Action.decrease를 reactor에 전달한다.
- reactor의 value 상태 변경시 valueLabel에 설정한다.
- reactor의 isLoading 상태 변경시 activityIndicatorView의 애니메이션 설정한다.
- reactor의 alertMessage인 경우 pulse를 사용하여 값이 새롭게 할당되는 경우에 항상 이벤트를 발생시킨다.
  상태 변경이 아니라 항상 새롭게 이벤트를 발생시켜야 할 경우에는 pulse를 사용한다.
