# SocialNexus iOS Product Specification

## 1) Concise Product Specification

**Product name:** SocialNexus  
**Primary user:** Owner/operator managing multiple brand social accounts.  
**Primary value:** One unified inbox for comment-driven activity and trend awareness across platforms.

### Core jobs-to-be-done
- See where new conversations are happening.
- Spot high-priority threads quickly (keyword, velocity, reputation risk).
- Open the exact source post/comment in the native platform with one tap.
- Monitor engagement and trend shifts over 24h/7d.

### Supported platforms (MVP)
- Facebook
- Instagram
- YouTube
- TikTok
- Rumble
- Odysee

### Additional recommended platforms and why
- **X (Twitter):** Fast-moving public discussion and quote-post dynamics are critical for reputation and crisis detection.
- **LinkedIn:** High-value B2B audiences; comment signals often map directly to business opportunities and brand perception.
- **Reddit:** Strong long-tail discussion and community sentiment, often where nuanced product feedback appears first.
- **Threads:** Growing Meta-native public conversation layer with overlap for Instagram-centric brands.
- **Pinterest:** Discovery-oriented traffic source; useful for monitoring saves, comments, and trend-aligned content resonance.
- **Google Business Profile (reviews):** Essential local reputation signal with direct impact on conversion and trust.

### Authentication and security requirements
- OAuth 2.0 (or platform equivalent) for all available providers.
- Access/refresh tokens stored in iOS Keychain (via `SecItemAdd/Update` wrapper).
- No raw password storage.
- Persistent sessions via refresh token rotation and token expiration tracking.
- Default all account connections to read-only scopes.
- Device-level encryption plus optional biometric gate before opening the app.

### Key entities and data captured
**Primary:** posts with new comments + latest comments list.

**Signals:**
- Conversation: new comments, replies, high-activity threads, keyword matches, optional sentiment trend.
- Visibility: shares/reposts, quote posts, duets/stitches/remixes, mentions/tags, detectable external links.
- Reputation: reviews, policy/strike warnings where available.
- Workflow: status tags (`Needs Reply`, `Escalate`, `Ignore`), saved searches, daily summary.

## 2) Information Architecture Diagram

```text
SocialNexusApp
│
├── Unified Feed (Home)
│   ├── Feed Row (Platform + Post + Latest Comment + Counts)
│   ├── Quick Open on Platform
│   └── Tap → Post Detail
│
├── Filters & Search
│   ├── Platforms
│   ├── Accounts
│   ├── Event Types
│   ├── Time Window
│   └── Keyword Search
│
├── Trends Dashboard
│   ├── Engagement Spikes
│   ├── Trending Keywords
│   ├── Sentiment Over Time
│   └── Most Active Posts (24h/7d)
│
├── Connected Accounts
│   ├── OAuth Connect Flow
│   ├── Permission Scope View
│   ├── Sync Status / Last Sync
│   └── Disconnect / Re-auth
│
└── Shared Data Layer
    ├── Platform Connectors
    ├── Sync Engine + Rate Limit Manager
    ├── Local Store (Core Data/SQLite)
    └── Keychain Token Vault
```

## 3) UX Flow Description

1. **Onboarding / first launch**
   - Intro screens: value + privacy + read-only defaults.
   - Connect account CTA launches OAuth web auth session.
2. **Connected Accounts setup**
   - User connects one or many platforms.
   - App validates scopes and stores tokens in Keychain.
3. **Unified Feed default landing**
   - Sorted by most recent actionable event.
   - Rows show platform, account, post snippet, latest comment, timestamp, counts.
4. **Row tap → Post Detail**
   - Full thread, metrics, event timeline, and deep link.
5. **Triage actions**
   - Mark `Needs Reply`, `Escalate`, or `Ignore` locally.
6. **Filters/Search**
   - Narrow by platform/account/event/time and keyword.
7. **Trends Dashboard**
   - Spot spikes and topic movement over rolling windows.

## 4) Visual Design Guidelines (HIG aligned)

- **Navigation:** `TabView` with 4 tabs: Feed, Trends, Search/Filters, Accounts.
- **Density:** card rows with clear hierarchy, 12–16pt spacing, one primary + one secondary action.
- **Typography:** SF Pro text styles (`.headline`, `.subheadline`, `.caption`).
- **Color:** semantic system colors (`.primary`, `.secondary`, `.tertiary`) and accessible contrast.
- **Platform recognition:** compact logo chip left-aligned in every row/detail header.
- **Motion:** subtle row highlight + skeleton loading; avoid heavy animation.
- **Dark mode:** same hierarchy with elevated surfaces (`.regularMaterial` or dark grouped backgrounds).
- **Performance:** thumbnail lazy loading + pagination.

## 5) Wireframe Descriptions

### A. Unified Feed
- **Top bar:** title, sync indicator, filter button.
- **Feed card layout:**
  - Left: platform logo badge.
  - Center: post title, newest comment preview, account/channel.
  - Right: engagement mini-metrics and open icon.
- **Bottom line:** timestamp + workflow tag chips.

### B. Post Detail
- Header card: platform + account + post preview + thumbnail.
- Metrics row: comments/replies/shares/mentions.
- Thread list: full comments in chronological groups.
- Sticky footer: `Open on Platform` primary button.

### C. Filters/Search
- Segmented controls for time window.
- Multi-select chips for platform/account/event type.
- Search bar with saved keyword presets.

### D. Trends Dashboard
- KPI strip: total comments, spike count, response backlog.
- Charts: sentiment sparkline, keyword trend bars.
- Ranked lists: most active posts (24h, 7d).

### E. Connected Accounts
- Per-platform cards: status, scope, last sync, re-auth button.
- Add account button with provider picker.
- Error state row for expired tokens/rate limits.

## 6) API limitations and integration strategy by platform

- **Facebook/Instagram (Meta Graph):** mature OAuth/scoped APIs; webhook + polling hybrid possible. Certain reply/moderation actions depend on page permissions and policy review.
- **YouTube Data API:** robust comments access; strict quota management required.
- **TikTok API:** business scope and endpoint availability vary; often backend token mediation is required.
- **Rumble/Odysee:** API breadth can be limited/non-uniform; may require RSS/official endpoints + backend normalization.
- **X:** API tiers can restrict volume/features; backend strongly recommended for rate management and unified retry policy.
- **LinkedIn:** permissions constrained by app review and use case; comments availability depends on approved scopes.
- **Reddit:** OAuth available; rate limits and community-specific restrictions apply.
- **Threads:** evolving API surface; likely backend needed for compatibility as endpoints mature.
- **Pinterest:** creator/business APIs available but limited conversational depth compared to other platforms.
- **Google Business Profile:** essential reviews ingestion, often easiest via backend due to token lifecycle and quota handling.

### Why backend aggregation is often required
- Unified normalization across inconsistent APIs.
- Secure refresh-token handling and rotation.
- Centralized rate-limit queue/retries/webhooks.
- Easier incremental sync bookkeeping per account/platform.
