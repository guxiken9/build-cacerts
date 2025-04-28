## cacertsの削除
rm -f ./cacerts

## Dockerイメージのビルド
docker build -t custom-truststore -f Dockerfile .

## Dockerコンテナの起動
docker run --name temp-container custom-truststore

## コンテナ上からホスト上にコピー
docker cp temp-container:/output/cacerts ./cacerts
