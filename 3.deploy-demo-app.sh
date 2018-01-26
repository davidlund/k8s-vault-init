kubectl apply -f demo-manifest/3.test-app.yaml

echo "Run the following command to see your token"
echo ""
echo 'kubectl exec -ndemo $(kubectl get pod -ndemo | grep "test-vault-deployment" | cut -f1 -d\  ) cat /vault/token'
echo ""
