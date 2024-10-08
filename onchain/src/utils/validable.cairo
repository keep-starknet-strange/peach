use core::num::traits::Zero;
use peach::contracts::peach::interface::{PeachEvent, TicketTierParams};

pub trait Validable<T> {
    fn is_valid(self: @T) -> bool;
}

// PeachEvent

pub const MAX_TICKET_TIERS_COUNT: u8 = 10;

pub impl PeachEventValidableImpl of Validable<PeachEvent> {
    fn is_valid(self: @PeachEvent) -> bool {
        // Checks: tresory_address
        if self.treasury_address.is_zero() {
            return false;
        }

        // Checks: ticket_tiers_params
        let mut len: u8 = 0;
        let mut is_valid = true;

        for ticket_tier_param in *self
            .ticket_tiers_params {
                if !ticket_tier_param.is_valid() {
                    is_valid = false;
                    break;
                }

                len += 1;
            };

        is_valid && len.is_non_zero() && len <= MAX_TICKET_TIERS_COUNT
    }
}

// TicketTier

pub impl TicketTierValidableImpl of Validable<TicketTierParams> {
    fn is_valid(self: @TicketTierParams) -> bool {
        self.max_supply.is_non_zero()
    }
}
