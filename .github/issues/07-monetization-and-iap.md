Title: Integrate AdMob banner + IAP for premium features and ad removal

Description:
Implement monetization to support the app's sustainability while keeping it usable in the free tier.

Implementation details:
- Add `google_mobile_ads` package for banner and interstitial ads; implement a banner placeholder in the product detail screen and optional interstitial at appropriate times.
- Add in-app purchases (IAP) via `in_app_purchase` or `revenuecat` integration to support a 'Remove Ads' and 'Family Sharing' subscription feature.
- Make the premium mode toggle a user-specific property in Supabase watchlist or in the local subscription state.
- Add polite prompts for rating and optional referral code reward system.

Tests:
- Mock ad and IAP services for development and test the presence/absence of ads in the UI for premium vs free users.
- Unit tests for purchase verification flows.

Acceptance criteria:
- Banner appears only to non-premium users and no longer shows once premium is active.
- Purchases are verifiable (e.g., using server verification or revenuecat if used).
- App gracefully handles ad provider failures without crashing.
