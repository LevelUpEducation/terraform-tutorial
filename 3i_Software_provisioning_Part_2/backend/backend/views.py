from django.http import JsonResponse, HttpResponse


def api_view(request):

	msg = request.GET["msg"]

	return HttpResponse("Hello, you sent me: " + msg)