import streamlit as st
from streamlit_chat import message
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain
from langchain.vectorstores import FAISS
import tempfile # 임시로 사용하는 파일 처리
from langchain.document_loaders import PyPDFLoader

import os
os.environ["OPENAI_API_KEY"] = "sk-"

uploaded_file = st.sidebar.file_uploader("upload", type = "pdf") # file 업로더

# 사용자에 의해 PDF 파일 업로드
if uploaded_file:
    # with문이 닫힐 때 임시로 불러들인 파일들도 없어짐
    with tempfile.NamedTemporaryFile(delete = False) as tmp_file: # delete = False, with문이 꺼지면 delete해야하는데 안되게 해둠!
        tmp_file.write(uploaded_file.getvalue()) # 업로드된 파일을 임시파일로 저장하겠다
        tmp_file_path = tmp_file.name # 저정한 녀석의 이름은 tmp_file

    loader = PyPDFLoader(tmp_file_path)
    data = loader.load()
    embeddings = OpenAIEmbeddings()
    vectors = FAISS.from_documents(data, embeddings)

    # ConversationalRetrievalChain 으로 대화형 챗봇 구성
    chain = ConversationalRetrievalChain.from_llm(
        llm = ChatOpenAI(temperature = 0, model_name = "gpt-4"),
        retriever = vectors.as_retriever()
        )
    
    # 문맥 유지를 위해 과거 대화 이력을 추가(append)
    def conversational_chat(query):
        result = chain({"question" : query, "chat_history" : st.session_state["history"]}) # history에 append((query, result["answer"]) 를 추가해줌
        st.session_state["history"].append((query, result["answer"]))
        return result["answer"]
    
    # 초기 질문과 답변에 대한 처리(PDF 파일이 업로드되면 보이는 화면 처리)
    if "history" not in st.session_state:
        st.session_state["history"] = [] # 히스토리가 없으면 비어있는 리스틀 만들어준다

    if "generated" not in st.session_state:
        # 초기 응답 메시지
        st.session_state["generated"] = ["안녕하세요! " + uploaded_file.name + "에 관해 질문 주세요."]

    if "past" not in st.session_state:
        st.session_state["past"] = ["안녕하세요!"]

    # 챗봇 이력에 대한 컨테이너
    response_container = st.container() # contaienr = 장고의 Bootstrap 같은 것
    # 사용자가 입력한 문장에 대한 컨테이너
    container = st.container()

    with container: # 대화내용 저장
        with st.form(key = "Conv_Question", clear_on_submit = True):
            user_input = st.text_input("Query:", 
                                       placeholder = "PDF파일에 대해 얘기해볼까요? (:",
                                       key = "input")
            submit_button = st.form_submit_button(label = "Send")

        # 사용자가 질문을 입력하거나 send 버튼을 눌렀을 때 처리
        if submit_button and user_input:
            output = conversational_chat(user_input)

            # 사용자의 질문이나 LLM에 대한 결과를 계속 추가
            st.session_state["past"].append(user_input)
            st.session_state["generated"].append(output)

    # LLM이 답변을 해야하는 경우에 대한 처리
    if st.session_state["generated"]: # 답변이 화면에 표시 되어야하는 경우
        with response_container:
            for i in range(len(st.session_state["generated"])): # generated를 순서대로 표시
                message(st.session_state["past"][i], is_user = True, 
                        # ["past"][i] = i번째 질문, is_user = True = 사용자의 질문이다
                        key = str(i) + "_user", avatar_style = "fun-emoji", seed = "Nala")
                        # avatar_style = "fun-emoji" = 이모지 넣기
                message(st.session_state["generated"][i], 
                        # ["generated"][i] = i번째 답변
                        key = str(i), avatar_style = "bottts", seed = "Fluffy")