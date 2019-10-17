let ws = require('ws')
let uuid = require('uuid')
var express = require('express');
var http = require('http');
// 创建socket服务，创建客户端连接数组
let socketServer = ws.Server
// let wss = new socketServer({port: 8090})
let clients = [];
let clientIndex = 0;
var app = express();
app.use(express.static(__dirname));

var server = http.createServer(app);
var wss = new socketServer({server});

console.log('server begin');

/**
 * 广播所有客户端消息
 * @param  {String} type     广播方式(admin为系统消息，user为用户消息)
 * @param  {String} message  消息
 * @param  {String} nickname 用户昵称，广播方式为admin时可以不存在
 */
function broadcastSend(type, message, nickname) {
    clients.forEach(function(v, i) {
        if(v.ws.readyState === ws.OPEN) {
            v.ws.send(JSON.stringify({
                "type": type,
                "nickname": nickname,
                "message": message
            }));
        }
    })
}

//监听连接
wss.on('connection', function(ws) {
    let client_uuid = uuid.v4();
    let nickname = 'AnonymousUser' + (clientIndex++)
    clients.push({
        "id": client_uuid,
        "ws": ws,
        "nickname": nickname
    });

    console.log(`client ${client_uuid} connected`);
    /**
     * 关闭服务，从客户端监听列表删除
     */
    function closeSocket() {
        for(let i = 0; i < clients.length; i++) {
          if(clients[i].id == client_uuid) {
            let disconnect_message = `${nickname} has disconnected`;
            broadcastSend("notification", disconnect_message, nickname);
            clients.splice(i, 1);
          }
        }
    }
    /*监听消息*/
    ws.on('message', function(message) {
        if(message.indexOf('/nick') === 0) {
            let nickname_array = message.split(' ');
            if(nickname_array.length >= 2) {
                let old_nickname = nickname;
                nickname = nickname_array[1];
                let nickname_message = `Client ${old_nickname} change to ${nickname}`;
                broadcastSend("nick_update", nickname_message, nickname);
            }
        } else {
            broadcastSend("message", message, nickname);
        }
        console.log(`client ${client_uuid} 发送 message`, message);
    });
    /*监听断开连接*/
    ws.on('close', function() {
        closeSocket();
        console.log(`client ${client_uuid} close`);
    })
})
console.log('server start');
server.listen(8090, function listening() {
    console.log('服务器启动成功！');
});
