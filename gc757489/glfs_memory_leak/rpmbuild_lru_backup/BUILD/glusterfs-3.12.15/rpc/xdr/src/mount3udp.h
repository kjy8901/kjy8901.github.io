/*
 * Please do not edit this file.
 * It was generated using rpcgen.
 */

#ifndef _MOUNT3UDP_H_RPCGEN
#define _MOUNT3UDP_H_RPCGEN

#include <rpc/rpc.h>


#ifdef __cplusplus
extern "C" {
#endif

#include "compat.h"
#include "xdr-nfs3.h"
#define MNTUDPPATHLEN 1024

typedef char *mntudpdirpath;

#define MOUNTUDP_PROGRAM 100005
#define MOUNTUDP_V3 3

#if defined(__STDC__) || defined(__cplusplus)
#define MOUNTUDPPROC3_NULL 0
extern  void * mountudpproc3_null_3(void *, CLIENT *);
extern  void * mountudpproc3_null_3_svc(void *, struct svc_req *);
#define MOUNTUDPPROC3_MNT 1
extern  mountres3 * mountudpproc3_mnt_3(mntudpdirpath *, CLIENT *);
extern  mountres3 * mountudpproc3_mnt_3_svc(mntudpdirpath *, struct svc_req *);
#define MOUNTUDPPROC3_UMNT 3
extern  mountstat3 * mountudpproc3_umnt_3(mntudpdirpath *, CLIENT *);
extern  mountstat3 * mountudpproc3_umnt_3_svc(mntudpdirpath *, struct svc_req *);
extern int mountudp_program_3_freeresult (SVCXPRT *, xdrproc_t, caddr_t);

#else /* K&R C */
#define MOUNTUDPPROC3_NULL 0
extern  void * mountudpproc3_null_3();
extern  void * mountudpproc3_null_3_svc();
#define MOUNTUDPPROC3_MNT 1
extern  mountres3 * mountudpproc3_mnt_3();
extern  mountres3 * mountudpproc3_mnt_3_svc();
#define MOUNTUDPPROC3_UMNT 3
extern  mountstat3 * mountudpproc3_umnt_3();
extern  mountstat3 * mountudpproc3_umnt_3_svc();
extern int mountudp_program_3_freeresult ();
#endif /* K&R C */

/* the xdr functions */

#if defined(__STDC__) || defined(__cplusplus)
extern  bool_t xdr_mntudpdirpath (XDR *, mntudpdirpath*);

#else /* K&R C */
extern bool_t xdr_mntudpdirpath ();

#endif /* K&R C */

#ifdef __cplusplus
}
#endif

#endif /* !_MOUNT3UDP_H_RPCGEN */