Description:
Prepare the app for public release by ensuring compliance and optimizing the experience.

Implementation details:
- Generate privacy policy explaining Keepa, Supabase, and Firebase usage, and how personal data is handled.
- Implement app metadata, screenshots, and promotional images for iOS and Android; add appropriate add/marketing assets.
- Optimize Android & iOS builds to reduce bundle size under 30MB if possible (minimization, reduce large assets, offload images to CDN), and consider split APKs / App Bundles.
- Ensure all declared permissions (camera, internet, notifications) are justified and described in the store listing.

Acceptance criteria:
- App store metadata prepared and privacy policy links are present.
- App can be uploaded to TestFlight and Play Console; passes initial automated checks.
- Bundle size is optimized (document steps for reduction; optionally implement code changes in `android/app/build.gradle` and iOS assets).
