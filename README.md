# GRANDLINE MOTORSPORT

**Race beyond the limit.** A 3D motorsport game built with Godot and GDScript, being adapted for Android.

Grandline Motorsport is the new identity for the former Velocity project. The goal is a mobile-first racing experience focused on Formula racing, with a clean pit-wall-inspired interface and responsive controls.

## Identity

- **Name:** Grandline Motorsport
- **Tagline:** Race beyond the limit.
- **Visual direction:** premium motorsport, near-black surfaces, white typography, racing red accents and restrained metallic gray
- **Interface principles:** clear hierarchy, readable race telemetry, large touch targets, no gradients, no unnecessary visual effects
- **Primary target:** Android phones; desktop input remains supported during development

## Existing game systems

The inherited project documents these systems; they still need to be verified in-engine before release:

- Multiple racing disciplines and procedural cars/tracks
- Formula racing with AI opponents, championship progression and DRS
- Race HUD, lap tracking, garage and player progression
- Godot `VehicleBody3D` vehicle physics

## Android adaptation status

This branch begins the mobile adaptation with Android-friendly project defaults:
- App identity changed to **Grandline Motorsport**
- Landscape orientation intended for racing gameplay
- 1280×720 logical viewport with canvas-item scaling
- Godot Compatibility renderer selected for broader mobile GPU support
- MSAA disabled to reduce GPU cost on entry-level phones

These settings are a starting point, not proof of a working APK. The project still needs an in-engine import/build test on the target Godot version.

## Current controls and next steps

Keyboard and gamepad controls are registered by `autoloads/input_manager.gd`. On-screen touch controls have **not yet been wired into the race scene**. That is the next gameplay change: add a mobile steering control, throttle and brake buttons, pause/reset actions, and make sure simultaneous touch input works without breaking keyboard/gamepad support.

## Build requirements

- Open the repository in the Godot version compatible with the project.
- Import and run `res://scenes/main.tscn`.
- Configure Android export templates and an Android SDK/JDK in Godot before exporting an APK.
- Validate on a physical Android device, including performance, touch controls, orientation, safe areas and suspend/resume.

See [ANDROID_ADAPTATION.md](ANDROID_ADAPTATION.md) for the implementation checklist.
