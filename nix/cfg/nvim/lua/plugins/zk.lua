local status, zk = pcall(require, "zk")
if not status then return end

zk.setup()
