import 'package:flutter/material.dart';
import 'package:phone_socket/pages/group/msg_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../foundation/msg_widget/other_msg_widget.dart';
import '../../foundation/msg_widget/own_msg_widget.dart';

class GroupPage extends StatefulWidget {
  final String name;
  final String userId;
  const GroupPage({super.key, required this.name, required this.userId});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  IO.Socket? socket;
  List <MsgModel>listMsg = [];
  TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('OK');
    connect();
  }


  void connect(){
    socket = IO.io("http://localhost:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    //print("We re here");
    socket!.onConnect((_) {
      print('Connected into frontend');
      socket!.on("sendMsgServer", (msg) {
        print(msg);
        if(msg["userId"]!=widget.userId){
          setState(() {
            listMsg.add(
              MsgModel(
                type: msg["type"], msg: msg["msg"], sender: msg["senderName"]
                )
            );
          });
        }
      });
      //socket.emit('msg', 'test');
    });
  }

  void sendMsg(String msg, String senderName){
    MsgModel ownMsg = MsgModel(type: "ownMsg", msg: msg, sender: senderName);
    listMsg.add(ownMsg);
    setState(() {
      listMsg;
    });
    socket!.emit('sendMsg', {
      "type":"ownMsg", 
      "msg":msg,
      "senderName": senderName,
      "userId": widget.userId
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anomynous group'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listMsg.length,
              itemBuilder: (context, index){
                if(listMsg[index].type == "ownMsg"){
                  return OwnMsgWidget(
                    msg: listMsg[index].msg, 
                    sender: listMsg[index].sender);
                } else {
                  return OtherMsgWidget(
                    msg: listMsg[index].msg,
                    sender: listMsg[index].sender);
                }
            })
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _msgController,
                    decoration:const  InputDecoration(
                      hintText: "Type here ...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2
                        )
                      )
                    ),
                  ),
                
                ),
                IconButton(
                  onPressed: (){
                    String msg = _msgController.text;
                    if(msg.isNotEmpty){
                      sendMsg(_msgController.text, widget.name);
                      _msgController.clear();
                    }

                    
                  }, 
                  icon: const Icon(
                    Icons.send,
                    color: Colors.teal,
                    size: 26,
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}