# Android adaptation checklist — Grandline Motorsport

## Goal
Adapt the existing Godot racing project for landscape Android phones, including entry-level hardware such as devices with 4 GB RAM. Preserve the existing game systems until they are tested.

## Identity and project defaults (started)
- [x] Rename the project in `project.godot` to Grandline Motorsport.
- [x] Set a 1280×720 logical landscape viewport and canvas-item scaling.
- [x] Select Godot's Compatibility renderer and disable 3D MSAA as a mobile baseline.
- [ ] Verify the correct Godot version and import the entire project.
- [ ] Run the main scene and inspect every menu and race scene for layout issues.
- [ ] Confirm Android export templates, SDK/JDK, package identifier, version and signing.

## Touch controls (wired in code; device testing still required)
The existing input manager reads InputMap actions. The new overlay writes virtual throttle, brake, steering and handbrake values that are merged into the existing player input accessors, keeping one vehicle-physics path. Pause and reset are wired to the race scene.

Required in-race overlay:
- Left steering zone: preferably a floating/virtual steering pad or left/right buttons.
- Right-side large **ACCELERATE** button.
- Separate **BRAKE** button, with optional handbrake as a smaller secondary control.
- **PAUSE** and **RESET** buttons at the upper corners.
- Optional look-back control only if the layout remains uncluttered.

Implementation requirements:
1. Use a `CanvasLayer` with touch-friendly `Control` nodes so it renders above the 3D race.
2. Make throttle and brake work while another finger is steering (multi-touch).
3. Release virtual inputs on `InputEventScreenTouch` release, focus loss, pause and scene changes to avoid stuck throttle.
4. Hide or disable touch controls on desktop and split-screen unless specifically enabled.
5. Keep controls away from Android cutouts and system gesture areas; allow left/right-handed layout if possible.
6. Add a settings option for button opacity/size and steering sensitivity.
7. Test on a real device; editor simulation is not sufficient.

## Performance plan
- Start with the Compatibility renderer and MSAA off; compare visuals/performance on-device before changing settings.
- Profile track scenes with the largest number of AI cars and procedural scenery.
- Reduce expensive real-time lights/shadows, particles, reflection effects and far-distance scenery on mobile.
- Use a scalable quality preset (Low / Balanced / High) and keep a stable frame pacing target.
- Avoid changing physics tick rate blindly: the current project documents 120 Hz for vehicle stability. Profile first, then test any reduction against car handling and collision reliability.
- Ensure scene loading is asynchronous where already supported and avoid rebuilding procedural geometry every frame.

## Validation checklist
- [ ] Main menu opens without script/import errors.
- [ ] Every car and track resource loads in an exported build.
- [ ] Race start, lap/checkpoint counting, AI, pause, restart and results work.
- [ ] Touch steering + throttle + brake can be pressed simultaneously.
- [ ] App can be backgrounded/resumed without stuck input or lost save data.
- [ ] Test memory, thermal behavior, loading time and sustained frame rate.
- [ ] Produce and install a signed APK; confirm package ID and app icon.

## Important status
The project configuration, identity, virtual touch input and race overlay are updated on branch `android-identity-adaptation`. This is not yet a verified Android release: no Godot import/headless test or APK export has been performed in this environment. Multi-touch, device focus changes and control placement must be tested on a real Android device.
