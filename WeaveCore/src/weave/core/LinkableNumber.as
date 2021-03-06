/*
    Weave (Web-based Analysis and Visualization Environment)
    Copyright (C) 2008-2011 University of Massachusetts Lowell

    This file is a part of Weave.

    Weave is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License, Version 3,
    as published by the Free Software Foundation.

    Weave is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Weave.  If not, see <http://www.gnu.org/licenses/>.
*/

package weave.core
{
	import mx.utils.ObjectUtil;
	
	/**
	 * LinkableNumber
	 * 
	 * 
	 * @author adufilie
	 */
	public class LinkableNumber extends LinkableVariable
	{
		public function LinkableNumber(defaultValue:Number = NaN, verifier:Function = null)
		{
			super(Number, verifier);
			_sessionState = NaN; // set to NaN instead of null because null==0
			if (!isNaN(defaultValue))
			{
				delayCallbacks();
				value = defaultValue;
				// Resume callbacks one frame later when we know it is possible for
				// other classes to have a pointer to this object and retrieve the value.
				StageUtils.callLater(this, resumeCallbacks, null, false);
			}
		}


		public function get value():Number
		{
			return _sessionState;
		}
		public function set value(value:Number):void
		{
			setSessionState(value);
		}

		override public function isUndefined():Boolean
		{
			return !_sessionStateWasSet || isNaN(_sessionState);
		}

		override public function setSessionState(value:Object):void
		{
			if (!(value is Number))
			{
				// use NaN instead of null because null gets converted to 0
				if (value == null)
					value = NaN;
				else
					value = Number(value);
			}
			super.setSessionState(value);
		}

		override protected function sessionStateEquals(otherSessionState:*):Boolean
		{
			if (isNaN(_sessionState) && isNaN(otherSessionState))
				return true;
			return _sessionState == otherSessionState;
		}
	}
}
