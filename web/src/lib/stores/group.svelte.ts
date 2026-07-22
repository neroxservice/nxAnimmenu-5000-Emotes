import { isFiveM, nui, type GroupState, type NearbyPlayer } from '../bridge';

interface PendingInvite {
  ownerId: number;
  ownerName: string;
}

class GroupStore {
  state = $state<GroupState | null>(null);
  isOwner = $state<boolean>(false);
  isPanelOpen = $state<boolean>(false);

  nearby = $state<NearbyPlayer[]>([]);
  isRefreshing = $state<boolean>(false);

  // Invite lifecycle is owned by Lua; we just render what GROUP_INVITE / GROUP_INVITE_CLEAR push.
  invite = $state<PendingInvite | null>(null);

  openPanel() {
    this.isPanelOpen = true;
    void this.refreshNearby();
  }

  closePanel() {
    this.isPanelOpen = false;
  }

  async refreshNearby() {
    if (this.isRefreshing) return;
    this.isRefreshing = true;
    const res = await nui.fetch<{ players: NearbyPlayer[] }>('GROUP_GET_NEARBY');
    this.nearby = res?.players ?? [];
    this.isRefreshing = false;
  }

  create() {
    void nui.fetch('GROUP_CREATE');
  }

  invitePlayer(targetId: number) {
    void nui.fetch('GROUP_INVITE', { targetId });
    this.nearby = this.nearby.filter((p) => p.id !== targetId);
  }

  kick(targetId: number) {
    void nui.fetch('GROUP_KICK', { targetId });
  }

  leave() {
    void nui.fetch('GROUP_LEAVE');
  }

  disband() {
    void nui.fetch('GROUP_DISBAND');
  }

  acceptInvite() {
    if (!this.invite) return;
    void nui.fetch('GROUP_ACCEPT_INVITE');
  }

  declineInvite() {
    if (!this.invite) return;
    void nui.fetch('GROUP_DECLINE_INVITE');
  }

  setInvite(invite: PendingInvite | null) {
    this.invite = invite;
  }

  applyState(state: GroupState | null, isOwner: boolean) {
    this.state = state;
    this.isOwner = isOwner;
    if (!state) this.nearby = [];
    else if (this.isPanelOpen) void this.refreshNearby();
  }
}

export const groupStore = new GroupStore();

if (isFiveM) {
  nui.on('GROUP_STATE', ({ group, isOwner }) => {
    groupStore.applyState(group, isOwner);
  });
  nui.on('GROUP_INVITE', ({ ownerId, ownerName }) => {
    groupStore.setInvite({ ownerId, ownerName });
  });
  nui.on('GROUP_INVITE_CLEAR', () => {
    groupStore.setInvite(null);
  });
}
