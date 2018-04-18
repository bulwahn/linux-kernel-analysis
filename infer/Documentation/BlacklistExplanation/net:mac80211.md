**File Location:** linux/net/mac80211  
**Kernel Version:**  Linux-stable v4.15  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Explanation When Not Blacklisted:**  
```
net/mac80211/status.o: In function `__ieee80211_tx_status':
net/mac80211/status.c:(.text+0x12d7): undefined reference to `ieee80211_mpsp_trigger_process'
net/mac80211/status.c:(.text+0x1678): undefined reference to `ieee80211s_update_metric'
net/mac80211/sta_info.o: In function `sta_info_insert_finish':
net/mac80211/sta_info.c:(.text+0x1bff): undefined reference to `mesh_accept_plinks_update'
net/mac80211/sta_info.o: In function `__cleanup_single_sta':
net/mac80211/sta_info.c:(.text+0x8c7c): undefined reference to `mesh_sta_cleanup'
net/mac80211/iface.o: In function `ieee80211_iface_work':
net/mac80211/iface.c:(.text+0x1a77): undefined reference to `ieee80211_mesh_rx_queued_mgmt'
net/mac80211/iface.c:(.text+0x1b5c): undefined reference to `ieee80211_mesh_work'
net/mac80211/iface.o: In function `ieee80211_teardown_sdata':
net/mac80211/iface.c:(.text+0x359d): undefined reference to `ieee80211_mesh_teardown_sdata'
net/mac80211/iface.o: In function `ieee80211_setup_sdata':
net/mac80211/iface.c:(.text+0x399e): undefined reference to `ieee80211_mesh_init_sdata'
net/mac80211/rx.o: In function `ieee80211_rx_h_sta_process':
net/mac80211/rx.c:(.text+0x5596): undefined reference to `ieee80211_mps_rx_h_sta_process'
net/mac80211/rx.o: In function `ieee80211_rx_h_action':
net/mac80211/rx.c:(.text+0x8a5b): undefined reference to `mesh_action_is_path_sel'
net/mac80211/tx.o: In function `ieee80211_xmit':
net/mac80211/tx.c:(.text+0x189a): undefined reference to `mesh_nexthop_resolve'
net/mac80211/tx.c:(.text+0x18bf): undefined reference to `ieee80211_mps_set_frame_flags'
Makefile:1000: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1
```
