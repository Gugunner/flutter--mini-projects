sealed class SqfliteStackError extends Error {}

class AlreadyExists extends SqfliteStackError {}

class NotFound extends SqfliteStackError {}

class CannotStore extends SqfliteStackError {}

class CannotDelete extends SqfliteStackError {}

class Unknown extends SqfliteStackError {}
