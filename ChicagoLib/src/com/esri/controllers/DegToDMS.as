package com.esri.controllers
{

/**
 * Utility class to pretty print decimal degree numbers.
 * @private
 */
public final class DegToDMS
{
    // Constants to define the format.
    public static const LAT:String = "lat";
    public static const LON:String = "lon";

    /**
     * Utility function to format a decimal degree number into a pretty string with degrees, minutes and seconds.
     * @param decDeg the decimal degree number.
     * @param decDir "lat" for a latitude number, "lon" for a longitude value.
     * @return A pretty print string with degrees, minutes and seconds.
     */
    public static function format(
        decDeg:Number,
        decDir:String
        ):String
    {
        var d:Number = Math.abs(decDeg);
        const deg:Number = Math.floor(d);
        d = d - deg;
        var min:Number = Math.floor(d * 60);
        const av:Number = d - min / 60;
        var sec:Number = Math.floor(av * 60 * 60);
        if (sec == 60)
        {
            min++;
            sec = 0;
        }
        if (min == 60)
        {
            deg++;
            min = 0;
        }
        const smin:String = min < 10 ? "0" + min + "' " : min + "' ";
        const ssec:String = sec < 10 ? "0" + sec + "\"" : sec + "\"";
        const sdir:String = (decDir == LAT) ? (decDeg < 0 ? "S " : "N ") : (decDeg < 0 ? "W " : "E ");
        return sdir + deg + "\xB0 " + smin + ssec;
    }
}

}
