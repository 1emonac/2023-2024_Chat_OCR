# Langchain + LLM(OpenAI) + Streamlit
#            <-> Vector DB

import os
from PyPDF2 import PdfReader
import streamlit as st
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings import HuggingFaceEmbeddings
from langchain import FAISS
from langchain.chains.question_answering import load_qa_chain
from langchain.chat_models import ChatOpenAI
from langchain.callbacks import get_openai_callback

def process_text(text):
    # 텍스트를 청크로 분할
    text_splitter = CharacterTextSplitter(
        separator = "\n", # 구분기준
        chunk_size = 1000, # 구분할 때, 한 단위의 데이터는 최대 1000자
        chunk_overlap = 200, # 인접된 chunk들을 200자정도 겹치게 저장
        length_function = len # chunk이 길이, 데이터를 쪼갰을 때, 한 청크의 길이들을 어떻게 잴 것이냐
    )
    chunks = text_splitter.split_text(text) # 데이터 쪼개줭

    # 임베딩 처리(벡터 변환)
    # 허깅페이스 모델을 이용해 임베딩 진행
    embeddings = HuggingFaceEmbeddings(model_name = "sentence-transformers/all-MiniLM-L6-v2")
    documents = FAISS.from_texts(chunks, embeddings) # FAISS = 대량의 고차원 벡터에서 유사성 검색 및 클러스터링을 빠르고 효율적으로 수행
    return documents

def main():
    st.title("☆PDF 요약서비스♡")
    st.divider()
    try:
        os.environ["OPENAI_API_KEY"] = "sk-"
    except ValueError as e:
        st.error(str(e))

    pdf = st.file_uploader("PDF파일을 업로드해주세요", type = "pdf")

    if pdf is not None:
        pdf_reader = PdfReader(pdf) # pdf reader가 읽을 것
        text = "" # text 변수에 PDF 내용을 저장
        for page in pdf_reader.pages: # 차례대로 누적될 것!
            text += page.extract_text () # 추출해!

        documents = process_text(text) # 문단별로 나누어진 document 별로 쪼개줄 것
        query = "업로드 된 PDF 파일의 내용을 3 ~ 5 문장으로 요약해주세요."
        # LLM에 PDF 파일 요약 요청
        
        if query:
            docs = documents.similarity_search(query) # documents = FAISS에 저장되어 있음 , query = 질문
            llm = ChatOpenAI(model = "gpt-3.5-turbo", temperature = 0.1)
            chain = load_qa_chain(llm, chain_type = "stuff")

            # request를 던질 때마다 요금이 나가기 때문에, 얼마나 요금이 드는지 보여줌
            with get_openai_callback() as cost:
                response = chain.run(input_documents = docs, question = query)
                print(cost)
            
            # 답변
            st.subheader("--요약 결과--:")
            st.write(response) # 요약 결과 밑에 나옴

# entry 포인트, 메인 함수 실행한당
if __name__ == "__main__":
    main()