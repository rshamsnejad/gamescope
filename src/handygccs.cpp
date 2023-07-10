#include <sys/ipc.h>
#include <unistd.h>
#include <sys/msg.h>
#include <cstring>

#include "steamcompmgr.hpp"
#include "main.hpp"

static bool inited = false;
static int msgid = 0;

struct handygccs_msg_header {
    long msg_type;  // Message queue ID, never change
    uint32_t version;  // for major changes in the way things work //
} __attribute__((packed));

struct handygccs_msg_v1 {
    struct handygccs_msg_header ft;

    uint64_t visible_frametime_ns;
    uint64_t app_frametime_ns;
    uint64_t latency_ns;
    // WARNING: Always ADD fields, never remove or repurpose fields
} __attribute__((packed)) handygccs_msg_v1;

void init_handygccs(){
    int key = ftok("handygccs", 76);
    msgid = msgget(key, 0666 | IPC_CREAT);
    inited = true;
}

void handygccs_update( uint64_t visible_frametime, uint64_t app_frametime_ns, uint64_t latency_ns ) {
    if (!inited)
        init_handygccs();

    handygccs_msg_v1.visible_frametime_ns = visible_frametime;
    handygccs_msg_v1.app_frametime_ns = app_frametime_ns;
    handygccs_msg_v1.latency_ns = latency_ns;
    msgsnd(msgid, &handygccs_msg_v1, sizeof(handygccs_msg_v1) - sizeof(handygccs_msg_v1.ft.msg_type), IPC_NOWAIT);
}

