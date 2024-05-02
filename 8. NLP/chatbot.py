# Langchain + LLM(OpenAI) + Streamlit
import streamlit as st
from langchain.llms import OpenAI
import os
os.environ["OPENAI_API_KEY"] = "sk-"

st.set_page_config(page_title = "뭐든지 질문하세요") # 페이지 설정 - 탭 제목
st.title("뭐든지 질문하세요~") # 제목

# llm이 답변 생성하는 함수
def generate_response(input_text): 
    llm = OpenAI(model_name = "gpt-3.5-turbo-instruct", temperature = 0)
    st.info(llm(input_text)) # llm input_text를 집어넣어서 info 틀에 답변 표시 # 아래에 파란색으로 나오는 부분을 지칭

with st.form("Question"): # form을 만들어 스트림릿!
    text = st.text_area("질문 입력:", "OpenAI는 어떤 유형의 텍스트 모델을 제공하나요?") # (#질문 ,#예시질문)
    submitted = st.form_submit_button("보내기") # 서버로 보낼 수 있는 버튼 만들기
    generate_response(text) # 보내기 버튼 클릭하면, 예시질문이 보내짐