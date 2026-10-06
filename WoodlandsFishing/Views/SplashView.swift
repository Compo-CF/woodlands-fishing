import SwiftUI

/// Animated Field Guide splash shown on cold launch while ContentView loads
/// data in the background. ~1.2s total animation; parent fades it out after
/// ~1.4s. Composition mirrors app-icon-1024: amber sun disc + bass + ink
/// hairline ring, on bone paper.
struct SplashView: View {
    @State private var discScale: CGFloat = 0.6
    @State private var discOpacity: Double = 0
    @State private var fishOpacity: Double = 0
    @State private var fishOffsetX: CGFloat = -24
    @State private var ringScale: CGFloat = 0.75
    @State private var ringOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var titleOffsetY: CGFloat = 16
    @State private var rippleOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.fgBone.ignoresSafeArea()

            VStack(spacing: FG.space.xxxl) {
                Spacer()

                // Icon stack
                ZStack {
                    // Ink hairline plate ring (expands in last)
                    Circle()
                        .stroke(Color.fgInk.opacity(0.85), lineWidth: 2)
                        .frame(width: 272, height: 272)
                        .scaleEffect(ringScale)
                        .opacity(ringOpacity)

                    // Amber sun disc (pops in first)
                    Circle()
                        .fill(Color.fgAmber)
                        .frame(width: 208, height: 208)
                        .scaleEffect(discScale)
                        .opacity(discOpacity)

                    // Bass silhouette (fades in + small left-to-center drift)
                    BassSilhouette()
                        .fill(Color.fgDeepLake)
                        .frame(width: 184, height: 92)
                        .offset(x: fishOffsetX)
                        .opacity(fishOpacity)
                }

                VStack(spacing: FG.space.sm) {
                    Text("Woodlands Fishing Guide")
                        .font(.fgDisplayLg)
                        .foregroundStyle(Color.fgInk)
                        .multilineTextAlignment(.center)
                    Text("A field guide to local waters")
                        .font(.fgSerifItalic)
                        .foregroundStyle(Color.fgSlate)
                }
                .opacity(titleOpacity)
                .offset(y: titleOffsetY)

                Spacer()

                // Water ripples at bottom — subtle finishing touch
                VStack(spacing: FG.space.sm) {
                    ripple(width: 120)
                    ripple(width: 80)
                    ripple(width: 48)
                }
                .opacity(rippleOpacity)
                .padding(.bottom, FG.space.x5)
            }
        }
        .onAppear(perform: runAnimation)
    }

    private func ripple(width: CGFloat) -> some View {
        Capsule()
            .fill(Color.fgSlate.opacity(0.35))
            .frame(width: width, height: 2)
    }

    private func runAnimation() {
        // Disc pops in from center with a soft spring
        withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
            discScale = 1
            discOpacity = 1
        }
        // Bass drifts in from the left and fades up
        withAnimation(.easeOut(duration: 0.55).delay(0.25)) {
            fishOpacity = 1
            fishOffsetX = 0
        }
        // Ring expands around the disc
        withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
            ringScale = 1
            ringOpacity = 1
        }
        // Title + subtitle rise and fade in
        withAnimation(.easeOut(duration: 0.5).delay(0.55)) {
            titleOpacity = 1
            titleOffsetY = 0
        }
        // Ripples ease in last
        withAnimation(.easeOut(duration: 0.6).delay(0.75)) {
            rippleOpacity = 1
        }
    }
}

/// Minimal field-guide bass silhouette, facing left. ~25-point outline — not
/// anatomically correct, just enough to read as "largemouth bass" at a glance.
private struct BassSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let cy = rect.midY

        let noseX = rect.minX
        let tailBaseX = rect.maxX - w * 0.15
        let tailTipX = rect.maxX

        p.move(to: CGPoint(x: noseX, y: cy))
        p.addLine(to: CGPoint(x: noseX + w * 0.04, y: cy - h * 0.22))
        p.addLine(to: CGPoint(x: noseX + w * 0.14, y: cy - h * 0.38))
        p.addLine(to: CGPoint(x: noseX + w * 0.30, y: cy - h * 0.48))
        p.addLine(to: CGPoint(x: noseX + w * 0.40, y: cy - h * 0.50))
        p.addLine(to: CGPoint(x: noseX + w * 0.43, y: cy - h * 0.88))
        p.addLine(to: CGPoint(x: noseX + w * 0.46, y: cy - h * 0.55))
        p.addLine(to: CGPoint(x: noseX + w * 0.49, y: cy - h * 0.88))
        p.addLine(to: CGPoint(x: noseX + w * 0.52, y: cy - h * 0.55))
        p.addLine(to: CGPoint(x: noseX + w * 0.55, y: cy - h * 0.88))
        p.addLine(to: CGPoint(x: noseX + w * 0.58, y: cy - h * 0.55))
        p.addLine(to: CGPoint(x: noseX + w * 0.68, y: cy - h * 0.62))
        p.addLine(to: CGPoint(x: noseX + w * 0.78, y: cy - h * 0.48))
        p.addLine(to: CGPoint(x: tailBaseX, y: cy - h * 0.30))
        p.addLine(to: CGPoint(x: tailTipX, y: cy - h * 0.50))
        p.addLine(to: CGPoint(x: tailBaseX + w * 0.04, y: cy))
        p.addLine(to: CGPoint(x: tailTipX, y: cy + h * 0.50))
        p.addLine(to: CGPoint(x: tailBaseX, y: cy + h * 0.30))
        p.addLine(to: CGPoint(x: noseX + w * 0.78, y: cy + h * 0.48))
        p.addLine(to: CGPoint(x: noseX + w * 0.60, y: cy + h * 0.55))
        p.addLine(to: CGPoint(x: noseX + w * 0.50, y: cy + h * 0.65))
        p.addLine(to: CGPoint(x: noseX + w * 0.40, y: cy + h * 0.50))
        p.addLine(to: CGPoint(x: noseX + w * 0.22, y: cy + h * 0.52))
        p.addLine(to: CGPoint(x: noseX + w * 0.10, y: cy + h * 0.35))
        p.addLine(to: CGPoint(x: noseX + w * 0.04, y: cy + h * 0.22))
        p.closeSubpath()

        return p
    }
}

#Preview("Splash — Light") {
    SplashView().preferredColorScheme(.light)
}

#Preview("Splash — Dark") {
    SplashView().preferredColorScheme(.dark)
}
