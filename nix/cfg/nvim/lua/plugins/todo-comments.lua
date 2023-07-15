local setup, todo_comments = pcall(require, "todo-comments")
if not setup then return end

todo_comments.setup()
