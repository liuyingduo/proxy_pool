FROM python:3.10-alpine

LABEL maintainer="jhao104 <j_hao104@163.com>"

WORKDIR /app

COPY ./requirements.txt .

# timezone and init process, using Tsinghua alpine mirror
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk add -U tzdata tini && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del tzdata

# runtime environment, using Tsinghua PyPI mirror
RUN apk add musl-dev gcc libxml2-dev libxslt-dev && \
    pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt && \
    apk del gcc musl-dev

COPY . .

EXPOSE 5010

ENTRYPOINT ["tini", "--", "bash", "proxy_pool.sh", "start", "--fg"]

