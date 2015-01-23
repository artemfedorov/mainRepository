package utils
{
		import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.DisplayObject;
        import flash.display.PixelSnapping;
        import flash.geom.Matrix;
        import flash.geom.Rectangle;
        
        /**
         * Crop util    
         * 
         *  @example
         *              var myCroppedImage:SmartBitmapBitmapBitmap = CropUtil.crop( this, 0, 0, 1366, 768);
         *              addChild(myCroppedImage);
         * 
         * @author Jack Klimov
         */
        public class CropUtil 
        {               
                /**
                 * Crop a image on the stage or in a movieclip
                 * 
                 * @param       inDisplayObject         object on the display list (this or foobarMovie)
                 * @param       inWidth                         width of the cropped image (default = 550)
                 * @param       inHeight                        height of the cropped image (default = 400)
                 * @param       inX                                     left starting point in pixels (default = 0)
                 * @param       inY                                     top starting point in pixels (default = 0)
                 * @param       inScale                         scale (default 1, don't know any reason to change that...)
                 * @return
                 */
                public static function crop( inDisplayObject:DisplayObject, inWidth:Number = 550, inHeight:Number = 400, inX:Number = 0, inY:Number = 0, inScale:Number = 1):Bitmap
                {
                        if (!inDisplayObject) { throw new Error('CropUtil.crop > needs a something on the display list'); return null; }
                        var cropArea:Rectangle = new Rectangle( 0, 0, inWidth * inScale, inHeight * inScale);
                        var croppedBitmap:Bitmap = new Bitmap( new BitmapData( inWidth * inScale, inHeight * inScale), PixelSnapping.ALWAYS, true );
                        croppedBitmap.bitmapData.draw( inDisplayObject, new Matrix(inScale, 0, 0, inScale, -inX, -inY), null, null, cropArea, true );
                        return croppedBitmap;
                }
        }
        
}