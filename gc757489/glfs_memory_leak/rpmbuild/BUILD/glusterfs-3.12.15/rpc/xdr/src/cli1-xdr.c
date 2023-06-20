/*
 * Please do not edit this file.
 * It was generated using rpcgen.
 */

#include "cli1-xdr.h"
#include "rpc-pragmas.h"
#include "compat.h"

bool_t
xdr_gf_cli_defrag_type (XDR *xdrs, gf_cli_defrag_type *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf_defrag_status_t (XDR *xdrs, gf_defrag_status_t *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cluster_type (XDR *xdrs, gf1_cluster_type *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf_bitrot_type (XDR *xdrs, gf_bitrot_type *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_op_commands (XDR *xdrs, gf1_op_commands *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf_quota_type (XDR *xdrs, gf_quota_type *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_friends_list (XDR *xdrs, gf1_cli_friends_list *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_get_volume (XDR *xdrs, gf1_cli_get_volume *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_sync_volume (XDR *xdrs, gf1_cli_sync_volume *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_op_flags (XDR *xdrs, gf1_cli_op_flags *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_gsync_set (XDR *xdrs, gf1_cli_gsync_set *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_stats_op (XDR *xdrs, gf1_cli_stats_op *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_info_op (XDR *xdrs, gf1_cli_info_op *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf_cli_get_state_op (XDR *xdrs, gf_cli_get_state_op *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_top_op (XDR *xdrs, gf1_cli_top_op *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf_cli_status_type (XDR *xdrs, gf_cli_status_type *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_snapshot (XDR *xdrs, gf1_cli_snapshot *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_snapshot_info (XDR *xdrs, gf1_cli_snapshot_info *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_snapshot_config (XDR *xdrs, gf1_cli_snapshot_config *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_snapshot_status (XDR *xdrs, gf1_cli_snapshot_status *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_snapshot_delete (XDR *xdrs, gf1_cli_snapshot_delete *objp)
{
	register int32_t *buf;

	 if (!xdr_enum (xdrs, (enum_t *) objp))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf_cli_req (XDR *xdrs, gf_cli_req *objp)
{
	register int32_t *buf;

	 if (!xdr_bytes (xdrs, (char **)&objp->dict.dict_val, (u_int *) &objp->dict.dict_len, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf_cli_rsp (XDR *xdrs, gf_cli_rsp *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->op_ret))
		 return FALSE;
	 if (!xdr_int (xdrs, &objp->op_errno))
		 return FALSE;
	 if (!xdr_string (xdrs, &objp->op_errstr, ~0))
		 return FALSE;
	 if (!xdr_bytes (xdrs, (char **)&objp->dict.dict_val, (u_int *) &objp->dict.dict_len, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_peer_list_req (XDR *xdrs, gf1_cli_peer_list_req *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->flags))
		 return FALSE;
	 if (!xdr_bytes (xdrs, (char **)&objp->dict.dict_val, (u_int *) &objp->dict.dict_len, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_peer_list_rsp (XDR *xdrs, gf1_cli_peer_list_rsp *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->op_ret))
		 return FALSE;
	 if (!xdr_int (xdrs, &objp->op_errno))
		 return FALSE;
	 if (!xdr_bytes (xdrs, (char **)&objp->friends.friends_val, (u_int *) &objp->friends.friends_len, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_fsm_log_req (XDR *xdrs, gf1_cli_fsm_log_req *objp)
{
	register int32_t *buf;

	 if (!xdr_string (xdrs, &objp->name, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_fsm_log_rsp (XDR *xdrs, gf1_cli_fsm_log_rsp *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->op_ret))
		 return FALSE;
	 if (!xdr_int (xdrs, &objp->op_errno))
		 return FALSE;
	 if (!xdr_string (xdrs, &objp->op_errstr, ~0))
		 return FALSE;
	 if (!xdr_bytes (xdrs, (char **)&objp->fsm_log.fsm_log_val, (u_int *) &objp->fsm_log.fsm_log_len, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_getwd_req (XDR *xdrs, gf1_cli_getwd_req *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->unused))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_getwd_rsp (XDR *xdrs, gf1_cli_getwd_rsp *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->op_ret))
		 return FALSE;
	 if (!xdr_int (xdrs, &objp->op_errno))
		 return FALSE;
	 if (!xdr_string (xdrs, &objp->wd, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_mount_req (XDR *xdrs, gf1_cli_mount_req *objp)
{
	register int32_t *buf;

	 if (!xdr_string (xdrs, &objp->label, ~0))
		 return FALSE;
	 if (!xdr_bytes (xdrs, (char **)&objp->dict.dict_val, (u_int *) &objp->dict.dict_len, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_mount_rsp (XDR *xdrs, gf1_cli_mount_rsp *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->op_ret))
		 return FALSE;
	 if (!xdr_int (xdrs, &objp->op_errno))
		 return FALSE;
	 if (!xdr_string (xdrs, &objp->path, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_umount_req (XDR *xdrs, gf1_cli_umount_req *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->lazy))
		 return FALSE;
	 if (!xdr_string (xdrs, &objp->path, ~0))
		 return FALSE;
	return TRUE;
}

bool_t
xdr_gf1_cli_umount_rsp (XDR *xdrs, gf1_cli_umount_rsp *objp)
{
	register int32_t *buf;

	 if (!xdr_int (xdrs, &objp->op_ret))
		 return FALSE;
	 if (!xdr_int (xdrs, &objp->op_errno))
		 return FALSE;
	return TRUE;
}
