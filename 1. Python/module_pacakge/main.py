# # 패키지 내부의 모듈을 읽어들임
# import test_package.module_a as a
# import test_package.module_b as b

# # 모듈 내부의 변수를 출력
# print(a.variable_a)
# print(b.variable_b)

# 패키지 내부의 모듈을 모두 읽어들임
from test_package import  *

# 모듈 내부의 변수를 출력
print(module_a.variable_a)
print(module_b.variable_b)