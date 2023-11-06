Class User.EmbPyTest Extends %RegisteredObject
{

/// Embedded Python で Mail 出す
ClassMethod EmbPyMail(Subject As %String, Body As %String) [ Language = python ]
{
	import boto3
	
	# 以下の値はダミーです
	accesskey = "AKIAABCDEFGHIJKLMNOP"
	secretkey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
	topic_arn = "arn:aws:sns:ap-northeast-1:012345678901:SnsTopicName"
    
	sns = boto3.resource("sns", aws_access_key_id=accesskey, aws_secret_access_key=secretkey, region_name="ap-northeast-1")

	response = sns.Topic(topic_arn).publish(
	        Message=Body,
	        Subject=Subject
	)
}

/// Object Script で Python パッケージ使ってMail出す
ClassMethod OscPyMail(Subject As %String, Body As %String) [ Language = objectscript ]
{
	Set boto3=##class(%SYS.Python).Import("boto3")
	
	// 以下の値はダミーです
	Set accesskey = "AKIAABCDEFGHIJKLMNOP"
	Set secretkey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
	Set topicArn = "arn:aws:sns:ap-northeast-1:012345678901:SnsTopicName"
	
	Set args={"aws_access_key_id":(accesskey), "aws_secret_access_key":(secretkey), "region_name": "ap-northeast-1" }

	S sns=boto3.resource("sns",args...)
	
	S msg={"Message":(Body), "Subject":(Subject) }
	S response=sns.Topic(topicArn).publish(msg...)
}

/// PIDを表示するだけ
ClassMethod WritePID() [ Language = python ]
{
    import os
    print(os.getpid())
}

ClassMethod CallSpeed()
{
	S times=1000	// 繰り返し回数
	
	W "$ZF(-1) Call: "
	S st=$ZH
	F i=1:1:times D $ZF(-1,"python /tmp/exit.py")
	W $ZH-st,"sec",!
	
	W "Embedded Python Call: "
	S st=$ZH
	F i=1:1:times D ..PyReturn()
	W $ZH-st,"sec",!
}

ClassMethod PyReturn() [ Language = python ]
{
	return
}

ClassMethod ParamRev()
{
	Set rev=..pyParamRev($H)
	Write rev.GetAt(1),!,rev.GetAt(2)
}

ClassMethod pyParamRev(horo) [ Language = python ]
{
	print(horo)
	n = 100
	s = "aaa"
	return n, s 	# 複数の値を返す
}

}
