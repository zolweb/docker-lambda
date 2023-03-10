# CHANGELOG

Tags come from node version installed + specific indication if needed.
Be careful : the list is ordered by more recent tag first, not node version it-self, as recent version may include fixes and are added only if needed.

## 18.14
Update date : 08/03/2023

- Update to node 18
- Change base image to use AWS directly
- Override entrypoint.sh to run the http server as daemon and send curl request directly

## 16.0.0
Update date : 12/10/2022 

- Initial release with a node 16 image.
