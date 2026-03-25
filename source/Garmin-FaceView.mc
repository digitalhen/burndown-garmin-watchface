import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class Garmin_FaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get body battery
        var bbCurrent = 0;
        var bbDayHigh = 0;
        var bbIter = SensorHistory.getBodyBatteryHistory({:period => new Time.Duration(86400)});
        if (bbIter != null) {
            var sample = bbIter.next();
            while (sample != null) {
                var val = sample.data;
                if (val != null) {
                    if (bbCurrent == 0) {
                        bbCurrent = val.toNumber();
                    }
                    if (val.toNumber() > bbDayHigh) {
                        bbDayHigh = val.toNumber();
                    }
                }
                sample = bbIter.next();
            }
        }

        // Draw square grid background, only within the circular display
        // Scale square size: day high 100 = 20px, day high 50 = 40px
        var squareSize = bbDayHigh > 0 ? (2000 / bbDayHigh).toNumber() : 20;
        if (squareSize < 16) { squareSize = 16; }
        if (squareSize > 56) { squareSize = 56; }
        var gap = 2;
        var cx = 140;
        var cy = 140;
        var radius = 138;
        var used = 100 - bbCurrent;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Collect visible squares in row-major order, centered on screen
        var visibleX = new [200];
        var visibleY = new [200];
        var visibleCount = 0;
        var cols = (280 + squareSize - 1) / squareSize;
        var rows = (280 + squareSize - 1) / squareSize;
        var offsetX = (280 - cols * squareSize) / 2;
        var offsetY = (280 - rows * squareSize) / 2;
        for (var row = 0; row < rows; row++) {
            for (var col = 0; col < cols; col++) {
                var x = offsetX + col * squareSize;
                var y = offsetY + row * squareSize;
                var midX = x + squareSize / 2;
                var midY = y + squareSize / 2;
                var dx = midX - cx;
                var dy = midY - cy;
                if (dx * dx + dy * dy <= radius * radius) {
                    visibleX[visibleCount] = x;
                    visibleY[visibleCount] = y;
                    visibleCount++;
                }
            }
        }

        // Scale body battery to visible squares (day high = full screen)
        var greenCount = 0;
        if (bbDayHigh > 0) {
            greenCount = (bbCurrent * visibleCount / bbDayHigh).toNumber();
        }
        var redCount = visibleCount - greenCount;
        for (var i = 0; i < visibleCount; i++) {
            if (i < redCount) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
            } else {
                dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_DK_GREEN);
            }
            dc.fillRectangle(visibleX[i], visibleY[i], squareSize - gap, squareSize - gap);
        }

        // Draw date
        var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$ $3$", [now.day_of_week, now.month, now.day]);

        // Draw time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);

        // Draw text with black outline then white fill
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        for (var ox = -1; ox <= 1; ox++) {
            for (var oy = -1; oy <= 1; oy++) {
                if (ox != 0 || oy != 0) {
                    dc.drawText(140 + ox, 105 + oy, Graphics.FONT_LARGE, dateString, Graphics.TEXT_JUSTIFY_CENTER);
                    dc.drawText(140 + ox, 140 + oy, Graphics.FONT_LARGE, timeString, Graphics.TEXT_JUSTIFY_CENTER);
                }
            }
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(140, 105, Graphics.FONT_LARGE, dateString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(140, 140, Graphics.FONT_LARGE, timeString, Graphics.TEXT_JUSTIFY_CENTER);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
