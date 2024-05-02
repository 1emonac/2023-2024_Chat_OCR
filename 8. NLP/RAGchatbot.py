import streamlit as st
from PyPDF2 import PdfReader
from langchain.embeddings import OpenAIEmbeddings, SentenceTransformerEmbeddings
from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain, RetrievalQA
from langchain.memory import ConversationBufferWindowMemory
from langchain.vectorstores import FAISS
from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter

import os
os.environ["OPENAI_API_KEY"] = "sk-"

# PDF 문서에서 텍스트 추출
def get_pdf_text(pdf_docs):
    text = ""
    for pdf in pdf_docs:
        pdf_reader = PdfReader(pdf)
        for page in pdf_reader.pages:
            text += page.extract_text()
    return text

# 지정된 조건에 따라 주어진 텍스트를 더 작은 덩어리로 분할
def get_text_chunks(text):
    # RecursiveCharacterTextSplitter : 일단 큰 덩어리 > 크기가 너무 크면 안에서 다시 한 번 쪼갠당
    text_splitter = RecursiveCharacterTextSplitter( 
        separators = "\n",
        chunk_size = 1000,
        chunk_overlap = 200,
        length_function = len
    )
    chunks = text_splitter.split_text(text)
    return chunks

# 주어진 텍스트 청크에 대해 임베딩을 생성하고 파이스를 사용하여 벡터 저장소를 생성
def get_vectorstore(text_chunks): # 문제가 발생한다면!: 임베딩 과정에서 문제가 발생했을 수도 있음
    embeddings = SentenceTransformerEmbeddings(model_name = "all-MiniLM-L6-v2")
    vectorstore = FAISS.from_texts(texts = text_chunks, embedding = embeddings)
    return vectorstore

# 주어진 벡터 저장소로 대화 체인을 초기화
def get_conversation_chain(vectorstore):
    # ConversationBufferWindowMemory 에 이전 대화 저장
    memory = ConversationBufferWindowMemory(memory_key = "chat_history", return_message = True)

    # ConversationalRetrievalChain을 통해 랭체인 챗봇에 쿼리 전송
    conversation_chain = ConversationalRetrievalChain.from_llm(
        llm = ChatOpenAI(temperature = 0, model_name = "gpt-3.5-turbo"),
        retriever = vectorstore.as_retriever(),
        get_chat_history = lambda h: h, # 전달 받은 내용을 history에 저장, 함수형태가 필요해서 lambda사용
        memory = memory # 위에서 만든 memory에 get_chat_history에 저장된 내용을 새로운 memory에 저장한다
    )
    return conversation_chain

user_uploads = st.file_uploader("파일을 업로드 해 주세요", accept_multiple_files = True) # accept_multiple_files 여러개 파일 업로드 가능!

if user_uploads is not None:
    if st.button("Upload"): # upload 버튼 생성
        with st.spinner("처리 중.."): # 처리 중 메시지 나옴
            # PDF 텍스트 가져오기
            raw_text = get_pdf_text(user_uploads)

            # 텍스트에서 청크 검색
            text_chunks = get_text_chunks(raw_text)

            # PDF 텍스트 저장을 위해 파이스 벡터 저장소 만들기
            vectorstore = get_vectorstore(text_chunks)

            # 대화 체인 만들기
            st.session_state.conversation = get_conversation_chain(vectorstore)

if user_query := st.chat_input("질문을 입력해주세요~"): # := 왈라스 연산자, chat_input을 할당하면서 user_query에 
    # 대화 체인을 사용하여 사용자의 메시지를 처리
    if "conversation" in st.session_state: # session = 하나의 DB가 있고 여러 애들이 접속하는 것
        # conversation이 있다 = 파일이 업로드 되어 있당
        result = st.session_state.conversation({
            "question" : user_query,
            "chat_history" : st.session_state.get("chat_history", [])
        })
        response = result["answer"]

    else:
        response = "먼저 문서를 업로드 해 주세요"

    with st.chat_message("assistant"):
        st.write(response)