# Momance 3D 개발 가이드

## [ARKit Guideline](https://developer.apple.com/ios/human-interface-guidelines/technologies/augmented-reality/)

## [SceneKit](https://developer.apple.com/documentation/scenekit) 정리
3D오브젝트를 사용하기 위해, 프로그래밍 방식으로 붙이거나, 3D 툴을 사용해서 만든 파일을 노드에 불러오게하는 두 가지 방식이 있다.(두 방식을 결합할 수도 있다.)

SceneKit은 Matrix를 사용하여 좌표 공간의 변화를 나타내며 3차원 공간에서 객체의 결합된 position(위치), rotation(회전), orientation(방향), scale(크기)를 나타낼 수 있다.

### [SCNNode](https://developer.apple.com/documentation/scenekit/scnnode)
SCNNode객체는 렌더링 될 때 보이지 않는다. 부모 노드에 상대적인 좌표 공간만 나타낸다. 장면을 구성하려면 노드에 Geometry를 add해서 보이는 내용을 만들고 Node를 Scene에 추가해야 한다.

rootNode객체는 SceneKit에 의해 렌더링 된 세계의 좌표계를 정의한다. rootNode에 추가하는 각 자식 노드는 고유한 좌표계를 만들고 차례대로 각자의 자식에 상속된다. 노드의 __위치__, __회전__ 및 __배율__ 특성을 사용하여 좌표계 간의 변환을 결정한다.

SCNNode로 만들어진 객체는 공간 및 논리 구조를 결정하지만, SCNNode 자체만으로는 눈에 보이는 contents는 존재하지 않는다. SCNGeometry 객체를 노드에 첨부하여, 2D 및 3D 객체를 SCNNode 객체에 추가한다. SCNMaterial객체가 모양을 결정하고, SCNLight객체는 음영처리를 담당한다. 렌더링할 때, 장면이 나타나는 viewPoint를 제어하려면 SCNCamera 객체가 있는 Node를 추가한다.

#### [transform](https://developer.apple.com/documentation/scenekit/scnnode/1407964-transform) property
transformation은 부모 노드를 기준으로 노드에 적용된다. transformation은 node의 rotation, position, scale 특성을 모두 가지고 있는 프로퍼티이다. 기본은 SCNMatrix4Identity 클래스이다.
transformation값을 설정하면 노드의 rotation, orientation, eulerAngles, position, scale 속성이 새로운 transform으로 자동 변경된다. SceneKit은 개발자가 제공한 transform이 rotation, translation, scale 연산을 했을때만 변환을 수행할 수 있다.

**Affine Space(어파인 공간)**
<pre>
위치에 대한 기준이 없는 벡터에 위치를 가진 점의 개념을 합쳐서 만든 공간
점-점 = 벡터
점+벡터 = 점
점+점 = 점 (but, 어파인 공간에서 점과 점의 합은 각 점의 계수의 합이 1일때만 허용된다. == Affine Sum)
</pre>

**Coordinate System(좌표계)**
<pre>
ARKit의 좌표계는 왼손 좌표계를 사용한다. 좌표계라는 것은 원점과 기반 벡터(다른 벡터를 스칼라 곱으로 나타낼 수 있는 단위 벡터)로  구성되는 프레임이다.
</pre>

**Homogeneous Coordinates(동차 좌표)**
<pre>
벡터냐 점이냐에 따라서 표현 방식은 달라야한다. 3차원의 3개의 요소로 표시할 것이 아니라 차원을 하나 올려서 4개의 요소로 표현하는 것이 동차 좌표이다.
ex)
 v = 4V1 + 2V2 + V3 + 0r    => 벡터 (4, 2, 1, 0)
 p = 4V1 + 2V2 + V3 + 1r    => 점 (4, 2 ,1 ,1)
점과 벡터는 각각 위의 예제처럼 나타낼 수 있다.
일반적으로 좌표의 변수로 (x, y, z ,w)와 같이 나타낸다.
3차원의 실제 좌표는 (x/w, y/w, z/w)로 나타낼 수 있다. 즉, w의 값이 0이냐 1이냐에 따라 점이냐 벡터냐로 나눌 수 있다.
</pre>

##### Translation(이동)
점 P=(x, y)에서 T(Tx, Ty)만큼 이동한 점이 P'=(x', y')으로 이라고 했을 때, 다음과 같이 정의할 수 있다.
  P' = T + P 

  [x'] = [Tx] + [x]
  [y']   [Ty]   [y]
그러나 컴퓨터 그래픽에서 일반적으로 덧셈 표현은 사용되지 않는다. 주로 행렬의 곱셈으로 표시된다.(GPU도 행렬의 곱셈연산에 최적화 되어있다.)




조절(S) 회전(R) 이동(T)을 하나의 연산으로 표시하면
C = TxRxS로 연산해야 한다.


## [What is ARKit](https://pilgwon.github.io/blog/2017/08/27/Why-is-ARKit-better-than-the-alternatives.html)?




