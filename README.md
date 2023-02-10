
# 랜덤 고양이 생성기(진행중)

[The Cat API - Cats as a Service.](https://thecatapi.com/)

-   출시를 고려하고있는 랜덤 고양이 생성기 프로젝트
-   The Cat API를 이용
-   1차적인 목표는 품종 설명 View를 완벽하게 만들고, 해당 품종만의 고양이 사진을 볼 수 있게 하는 부가기능 완성
-   `개발 진행중`

# TODO

-   `메인 View`
    
    -   메인 View 구성
    -   랜덤 고양이 이미지 받아오기
    -   로딩 화면 구현
    -   특정 품종의 고양이로만 랜덤 사진 받아오기 구현
    
-   `품종 상세 View`
    -   품종별 정보 View DropDown을 사용해 구성
    -   Chart 구현하기
    -   단순히 Kingfisher로 받아와 할당한 ImageView를 ImageSlideshow로 바꾸기
        -   이미지 로딩 indicator 고민해보기
    -   `SwiftGoogleTranslate`  사용해서 품종 정보 View 번역해서 표시
-   `앱 전체`
    -   런치 View 구현
    -   런치 View 포함 전체적인 디자인 재구성 (디자이너 섭외 고려해보기)

# 런치 스크린 & 메인화면

  
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/cbd1bc51-ea1d-47c0-b53d-482971e6ab3c/1.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T033235Z&X-Amz-Expires=86400&X-Amz-Signature=fd1100d1b1ab78b70f432fa69ad3be7e943e665d912a532083388f19bd0e1c46&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%221.gif%22&x-id=GetObject)

-   Lottie 라이브러리를 이용해 런치화면과 로딩화면 구성
-   Alamofire와 Kingfisher를 이용한 고양이 사진 Fetching

# 품종별 설명 화면

  
![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/4fe53252-fc1e-41e5-9c39-c83304df4490/Feb-07-2023_18-44-48.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20230210%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230210T033246Z&X-Amz-Expires=86400&X-Amz-Signature=50f8e725a0a78c40b39e74ef94aad95b92434a9f64d046a329a90b147aee4eda&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Feb-07-2023%252018-44-48.gif%22&x-id=GetObject)

-   품종을 클릭하여 해당 품종 사진과 설명등을 볼 수 있다.
-   DropDown으로 품종선택
-   ImageSlideshow 라이브러리를 사용한 이미지 슬라이드 뷰 표시
-   품종 설명
-   Charts 라이브러리로 Radar 차트 구현
