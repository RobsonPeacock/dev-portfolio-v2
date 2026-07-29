function handler(event) {
    var request = event.request;
    
    request.uri = request.uri.replace(/^\/api/, '');
    if (request.uri === '') {
        request.uri = '/';
    }

    return request;
}