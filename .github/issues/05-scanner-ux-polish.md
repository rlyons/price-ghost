Title: Improve Scanner UX: auto-focus, low-light handling, multiple barcode selection, gallery import

Description:
Enhance the scanner screen and scanning UX with features and robustness:
- Animated glassmorphic overlay and more refined brackets (already present); add polished animations and transitions.
- Auto-focus handling and camera exposure to improve scan accuracy; fall back to gallery import for non-camera access.
- Handle multiple barcodes in the frame: show a small overlay list for the user to select which barcode to process.
- Improve low-light handling: if the scan fails in low-light, prompt auto-flash or manual flash option.

Implementation details:
- Use `mobile_scanner` features for focus/exposure; add explicit method calls on tap to set focus point.
- Implement gallery import using `image_picker` and barcode image processing with a lookup library (or send to server for OCR/barcode detection).
- Add a small floating overlay that lists found barcodes when multiple are detected; tapping an entry triggers product lookup.
- Add polished haptic, sound, or animation feedback on successful scans.

Tests to add:
- Widget tests for overlay components.
- Unit tests for multiple-barcode selection logic.

Acceptance criteria:
- Scans reliably in normal light; low-light prompts auto-flash and instructs user when device prevents torch.
- Display multiple barcodes found; user can select one for lookup.
- Gallery import allows users to select an image; the app extracts barcode and proceeds exactly as if scanned.
- UX changes are covered by widget tests.
