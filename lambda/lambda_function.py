def lambda_handler(event, context):
    print("Hello World! This Lambda is triggered by a cron job every 5 minutes.")
    return {"statusCode": 200, "body": "Success"}