FROM public.ecr.aws/lambda/nodejs:18.2023.02.28.14

COPY script/entrypoint.sh /zol-entrypoint.sh

ENTRYPOINT ["/zol-entrypoint.sh"]

CMD [ "index.handler" ]