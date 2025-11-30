High Priority (Foundation - Implement First)
#14: Fix incomplete .env.example file - missing BARCODE_LOOKUP_KEY ✅ COMPLETED

Why first: Blocks proper development setup for contributors
Effort: 5 minutes
Impact: Critical for onboarding
Completed: Already implemented in previous PR #13
#15: Update outdated dependencies and fix flutter_local_notifications Linux plugin issue ✅ COMPLETED

Why next: Security risks, build warnings on every run
Effort: 1-2 hours (incremental updates)
Impact: Eliminates build noise, security fixes
Completed: PR #21 created with major dependency updates, all tests pass
Updated: CI workflow changed to use Flutter stable to fix potential compatibility issues
#16: Add Flutter linting configuration (analysis_options.yaml) ✅ COMPLETED

Why: Ensures consistent code quality
Effort: 15 minutes
Impact: Prevents code quality degradation
Completed: PR #22 created with analysis_options.yaml and flutter_lints added
Note: After PR #21 is merged, rebase this branch on main to ensure compatibility with updated dependencies
#17: Upgrade Riverpod from 2.6.1 to 3.0 ✅ COMPLETED

Why: Architecture consistency with project guidelines
Effort: 30-60 minutes (API changes)
Impact: Better performance, latest features
Completed: PR #23 created with full Riverpod 3.0 migration
Medium Priority (Testing & DevOps)
#18: Add integration tests for full app flows ✅ COMPLETED

Why: Current unit tests don't cover end-to-end flows
Effort: 2-4 hours
Impact: Catches integration bugs, increases confidence
Completed: Added comprehensive integration test suite with 6 tests covering:
- Product lookup flow with fallback services
- Buy signal prediction integration
- Error handling with fallback to demo data
- Watchlist provider full lifecycle
- Fallback service integration and retry logic
- CI updated to run integration tests (37 total tests passing)
#19: Enhance CI/CD pipeline with build artifacts and coverage reporting ✅ COMPLETED

Why: Professional CI/CD, automated builds
Effort: 1-2 hours
Impact: Easier testing/distribution, coverage tracking
Note: Overlaps with existing #8 - consider updating #8 instead
Completed: Enhanced CI/CD pipeline with:
- Codecov integration for coverage reporting
- Android APK build artifacts uploaded to GitHub Actions
- Bundle size analysis
- Flutter doctor diagnostics
- Dependency audit with flutter pub outdated
- All CI checks passing
#20: Improve Firebase setup documentation

Why: Reduces contributor setup friction
Effort: 30-45 minutes
Impact: Better onboarding experience
Status: NOT STARTED - Next priority task
Low Priority (Features - Implement After Foundation)
#3: Add Supabase authentication and watchlist sync

Why: Core user functionality
Effort: 4-8 hours
Impact: Multi-device sync capability
#4: Implement background pricing checker as a Cloud Function to send push notifications

Why: Core price monitoring feature
Effort: 6-12 hours
Impact: Automated price alerts
#5: Improve Scanner UX: auto-focus, low-light handling, multiple barcode selection, gallery import

Why: User experience enhancement
Effort: 3-6 hours
Impact: Better scanning reliability
#6: Add more watchlist UI features: item details, thresholds, notification settings, and bulk actions

Why: Enhanced watchlist management
Effort: 4-8 hours
Impact: Improved user workflow
#7: Integrate AdMob banner + IAP for premium features and ad removal

Why: Monetization strategy
Effort: 4-6 hours
Impact: Revenue generation
#9: App Store & Play Store readiness: privacy policy, screenshots, bundle size, and ASO

Why: Pre-launch preparation
Effort: 2-4 hours
Impact: Store approval readiness
#10: Implement analytics and crash reporting

Why: Post-launch monitoring
Effort: 2-3 hours
Impact: User behavior insights, crash tracking
Additional Notes
Existing #8 ("Add integration tests and expand CI coverage") can be closed or updated since it's covered by #18 and #19
Total new issues created: 7
Foundation issues (1-4) should be completed before any feature work
Effort estimates are rough and assume experienced Flutter development
Testing: Each issue should include test updates and verification
Documentation: Update README.md and CONTRIBUTING.md as needed
