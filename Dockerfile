FROM public.ecr.aws/lambda/nodejs:20.2023.11.21.13

COPY script/entrypoint.sh /zol-entrypoint.sh

ENTRYPOINT ["/zol-entrypoint.sh"]

CMD [ "index.handler" ]