# ベースイメージとして軽量なOpenJDKを使用（Alpine）
FROM openjdk:8-jdk-alpine

# 必要なツールをインストール
RUN apk add --no-cache curl perl bash ca-certificates openssl

# ワーキングディレクトリの作成
WORKDIR /opt/truststore

# certdata.txtの取得
RUN update-ca-certificates
RUN curl -L -o certdata.txt https://hg.mozilla.org/projects/nss/raw-file/default/lib/ckfw/builtins/certdata.txt

# スクリプトをコピー（ビルドコンテキストに配置しておく必要あり）
COPY mk-ca-bundle.pl .
COPY mk-cacerts.sh .

# スクリプトに実行権限を付与
RUN chmod +x mk-ca-bundle.pl mk-cacerts.sh

# カスタムcacertsの生成
RUN ./mk-ca-bundle.pl -n
RUN ./mk-cacerts.sh

# 出力されたカスタムcacertsを外部に出力するためにコピー用ディレクトリを作成
RUN mkdir /export && cp cacerts /export/

# 最終ステージ（ビルド後、成果物だけを含めたい場合に便利）
FROM alpine:3.21
COPY --from=0 /export/cacerts /output/cacerts
