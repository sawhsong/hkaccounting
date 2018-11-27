/*
 *contextMenu.js v 1.4.1
 *Author: Sudhanshu Yadav
 *s-yadav.github.com
 *http://ignitersworld.com/lab/contextMenu.html
 *Copyright (c) 2013-2015 Sudhanshu Yadav.
 *Dual licensed under the MIT and GPL licenses
 */
;
(function($, window, document, undefined) {
	"use strict";

	$.single = (function() {
		var single = $({});
		return function(elm) {
			single[0] = elm;
			return single;
		};
	}());

	$.fn.contextMenu = function(method, selector, option) {
		//parameter fix
		if (!methods[method]) {
			option = selector;
			selector = method;
			method = 'popup';
		}
		//need to check for array object
		else if (selector) {
			if (!((selector instanceof Array) || (typeof selector === 'string') || (selector.nodeType) || (selector.jquery))) {
				option = selector;
				selector = null;
			}
		}

		if ((selector instanceof Array) && (method != 'update')) {
			method = 'menu';
		}

		var myoptions = option;
		if ($.inArray(method, [ 'menu', 'popup', 'close', 'destroy' ]) > -1) {
			option = iMethods.optionOtimizer(method, option);
			this.each(function() {
				var $this = $(this)
				myoptions = $.extend({}, $.fn.contextMenu.defaults, option);
				if (!myoptions.baseTrigger) {
					myoptions.baseTrigger = $this;
				}
				methods[method].call($this, selector, myoptions)
			});
		} else {
			methods[method].call(this, selector, myoptions)
		}
		return this;
	};

	$.fn.contextMenu.defaults = {
		// Dustin modified
		effect:"fade", // Dustin : slide / fade
		effectDuration:200, // Dustin : 'blind', 'fade', 'slide', 'drop'
		classPrefix:"iw", // Dustin : to use various class
		widthAdjust:0, // Dustin : width adjustment
		heightAdjust:0, // Dustin : height adjustment

		triggerOn : 'click', //avaliable options are all event related mouse plus enter option
		subMenuTriggerOn : 'hover click',
		displayAround : 'cursor', // cursor or trigger
		mouseClick : 'left',
		verAdjust : 0,
		horAdjust : 0,
		top : 'auto',
		left : 'auto',
		closeOther : true, //to close other already opened context menu
		containment : window,
		winEventClose : true,
		position : 'auto', //allowed values are top, left, bottom and right
		closeOnClick : true, //close context menu on click/ trigger of any item in menu

		//callback
		onOpen : function(data, event) {},
		afterOpen : function(data, event) {},
		onClose : function(data, event) {}
	};

	var methods = {
		menu : function(selector, option) {
			selector = iMethods.createMenuList(this, selector, option);
			iMethods.contextMenuBind.call(this, selector, option, 'menu');
		},
		popup : function(selector, option) {
//			$(selector).addClass('iw-contextMenu');
			$(selector).addClass(option.classPrefix+'-contextMenu');
			iMethods.contextMenuBind.call(this, selector, option, 'popup');
		},
		update : function(selector, option) {
			var self = this;
			option = option || {};

			this.each(function() {
				var trgr = $(this), menuData = trgr.data('iw-menuData');
				//refresh if any new element is added
				if (!menuData) {
					self.contextMenu('refresh');
					menuData = trgr.data('iw-menuData');
				}

				var menu = menuData.menu;
				if (typeof selector === 'object') {
					for (var i = 0; i < selector.length; i++) {
						var name = selector[i].name,
							disable = selector[i].disable,
							fun = selector[i].fun,
							icon = selector[i].icon,
							img = selector[i].img,
							title = selector[i].title,
							className = selector[i].className,
							elm = menu.children('li').filter(function() {
								return $(this).contents().filter(function() {
									return this.nodeType == 3;
								}).text() == name;
							}),
							subMenu = selector[i].subMenu;

						//toggle disable if provided on update method
						disable != undefined && (disable ? elm.addClass(option.classPrefix+'-mDisable') : elm.removeClass(option.classPrefix+'-mDisable'));

						//bind new function if provided
						fun && elm.unbind('click.contextMenu').bind('click.contextMenu', fun);

						//update title
						title != undefined && elm.attr('title', title);

						//update class name
						className != undefined && elm.attr('class', className);

						var imgIcon = elm.find('.'+option.classPrefix+'-mIcon');
						if (imgIcon.length)
							imgIcon.remove();

						//update image or icon
						if (img) {
							elm.prepend('<img src="'+img+'" align="absmiddle" class="'+option.classPrefix+'-mIcon" />');
						} else if (icon) {
							elm.prepend('<span align="absmiddle" class="'+option.classPrefix+'-mIcon '+icon+'" />');
						}

						//to change submenus
						if (subMenu) {
							elm.contextMenu('update', subMenu);
						}
					}
				}

				iMethods.onOff(menu);

				//bind event again if trigger option has changed.
				var triggerOn = option.triggerOn;
				if (triggerOn) {
					trgr.unbind('.contextMenu');

					//add contextMenu identifier on all events
					triggerOn = triggerOn.split(" ");
					var events = [];
					for (var i = 0, ln = triggerOn.length; i < ln; i++) {
						events.push(triggerOn[i] + '.contextMenu')
					}

					//to bind event
					trgr.bind(events.join(' '), iMethods.eventHandler);
				}

				//set menu data back to trigger element
				menuData.option = $.extend({}, menuData.option, option);
				trgr.data('iw-menuData', menuData);
			});
		},
		refresh : function() {
			var menuData = this.filter(function() {
				return !!$(this).data('iw-menuData');
			}).data('iw-menuData'), newElm = this.filter(function() {
				return !$(this).data('iw-menuData');
			});
			//to change basetrigger on refresh  
			menuData.option.baseTrigger = this;
			iMethods.contextMenuBind.call(newElm, menuData.menuSelector, menuData.option);
		},
		open : function(sel, data) {
			data = data || {};
			var e = data.event || $.Event('click');
			if (data.top)
				e.clientY = data.top;
			if (data.left)
				e.clientX = data.left;
			this.each(function() {
				iMethods.eventHandler.call(this, e);
			});
		},
		//to force context menu to close
		close : function() {
			var menuData = this.data('iw-menuData');
			if (menuData) {
				iMethods.closeContextMenu(menuData.option, this, menuData.menu, null);
			}
		},
		//to get value of a key
		value : function(key) {
			var menuData = this.data('iw-menuData');
			if (menuData[key]) {
				return menuData[key];
			} else if (menuData.option) {
				return menuData.option[key];
			}
			return null;
		},
		destroy : function() {
			var trgr = this,
				menuId = trgr.data('iw-menuData').menuId,
				menu = $('.'+option.classPrefix+'-contextMenu[menuId=' + menuId + ']'),
				menuData = menu.data('iw-menuData');

			//Handle the situation of dynamically added element.
			if (!menuData)
				return;

			if (menuData.noTrigger == 1) {
				if (menu.hasClass(option.classPrefix+'-created')) {
					menu.remove();
				} else {
					menu.removeClass(option.classPrefix+'-contextMenu ' + menuId).removeAttr('menuId').removeData('iw-menuData');
					//to destroy submenus
					menu.find('li.'+option.classPrefix+'-mTrigger').contextMenu('destroy');
				}
			} else {
				menuData.noTrigger--;
				menu.data('iw-menuData', menuData);
			}
			trgr.unbind('.contextMenu').removeClass(option.classPrefix+'-mTrigger').removeData('iw-menuData');
		}
	};
	var iMethods = {
		contextMenuBind : function(selector, option, method) {
			var trigger = this,
				menu = $(selector),
				menuData = menu.data('iw-menuData');

			//fallback
			if (menu.length == 0) {
				menu = trigger.find(selector);
				if (menu.length == 0) {
					return;
				}
			}

			if (method == 'menu') {
				/*!
				 * Dustin : effect
				 */
//				iMethods.menuHover(menu);
				iMethods.menuHover(menu, option);
			}
			//get base trigger
			var baseTrigger = option.baseTrigger;

			if (!menuData) {
				var menuId;
				if (!baseTrigger.data('iw-menuData')) {
					menuId = Math.ceil(Math.random() * 100000);
					baseTrigger.data('iw-menuData', {
						'menuId' : menuId
					});
				} else {
					menuId = baseTrigger.data('iw-menuData').menuId;
				}
				//create clone menu to calculate exact height and width.
				var cloneMenu = menu.clone();
				cloneMenu.appendTo('body');

				// Dustin - height adjustment
				var heightAdjustment = option.heightAdjust || 0;

				menuData = {
					'menuId' : menuId,
					'menuWidth' : cloneMenu.outerWidth(true),
					'menuHeight' : cloneMenu.outerHeight(true)+heightAdjustment,
					'noTrigger' : 1,
					'trigger' : trigger,
					"effect":option.effect // Dustin : effect
				};

				//to set data on selector
				menu.data('iw-menuData', menuData).attr('menuId', menuId);
				//remove clone menu
				cloneMenu.remove();
			} else {
				menuData.noTrigger++;
				menu.data('iw-menuData', menuData);
			}

			//to set data on trigger
			trigger.addClass(option.classPrefix+'-mTrigger').data('iw-menuData', {
				'menuId' : menuData.menuId,
				'option' : option,
				'menu' : menu,
				'menuSelector' : selector,
				'method' : method
			});

			//hover fix
			var triggerOn = option.triggerOn;
			if (triggerOn.indexOf('hover') != -1) {
				triggerOn = triggerOn.replace('hover', 'mouseenter');
				//hover out if display is of context menu is on hover
				if (baseTrigger.index(trigger) != -1) {
					baseTrigger.add(menu).bind(
						'mouseleave.contextMenu',
						function(e) {
							if ($(e.relatedTarget).closest('.'+option.classPrefix+'-contextMenu').length == 0) {
								$('.'+option.classPrefix+'-contextMenu[menuId="' + menuData.menuId + '"]').fadeOut(100);
							}
					});
				}
			}

			trigger.delegate('input,a,.needs-click', 'click', function(e) {
				e.stopImmediatePropagation()
			});

			//add contextMenu identifier on all events
			triggerOn = triggerOn.split(' ');
			var events = [];
			for (var i = 0, ln = triggerOn.length; i < ln; i++) {
				events.push(triggerOn[i] + '.contextMenu')
			}

			//to bind event
			trigger.bind(events.join(' '), iMethods.eventHandler);

			//to stop bubbling in menu
			menu.bind('click mouseenter', function(e) {
				e.stopPropagation();
			});

			menu.delegate('li', 'click', function(e) {
				if (option.closeOnClick
						&& !$.single(this).hasClass('iw-has-submenu'))
					iMethods.closeContextMenu(option, trigger, menu, e);
			});
		},
		eventHandler : function(e) {
			e.preventDefault();
			var trigger = $(this),
				trgrData = trigger.data('iw-menuData'),
				menu = trgrData.menu,
				menuData = menu.data('iw-menuData'),
				option = trgrData.option,
				cntnmnt = option.containment,
				clbckData = {
					trigger : trigger,
					menu : menu
				},
			//check conditions
			cntWin = cntnmnt == window,
			btChck = option.baseTrigger.index(trigger) == -1;

			//to close previous open menu.
			if (!btChck && option.closeOther) {
				$('.'+option.classPrefix+'-contextMenu').css('display', 'none');
			}

			//to reset already selected menu item
			menu.find('.'+option.classPrefix+'-mSelected').removeClass(option.classPrefix+'-mSelected');

			//call open callback
			option.onOpen.call(this, clbckData, e);

			var cObj = $(cntnmnt),
				cHeight = cObj.innerHeight(),
				cWidth = cObj.innerWidth(),
				cTop = 0,
				cLeft = 0,
				menuHeight = menuData.menuHeight,
				menuWidth = menuData.menuWidth,
				va,
				ha,
				left = 0,
				top = 0,
				bottomMenu,
				rightMenu,
				verAdjust = va = parseInt(option.verAdjust),
				horAdjust = ha = parseInt(option.horAdjust);

			if (!cntWin) {
				cTop = cObj.offset().top;
				cLeft = cObj.offset().left;

				//to add relative position if no position is defined on containment
				if (cObj.css('position') == 'static') {
					cObj.css('position', 'relative');
				}
			}

			// Dustin - width adjustment
			var widthAdjustment = option.widthAdjust || 20;
			var heightAdjustment = option.heightAdjust || 0;
			if (option.sizeStyle == 'auto') {
				menuHeight = Math.min(menuHeight, cHeight);
				menuHeight = (menuHeight + heightAdjustment);

				menuWidth = Math.min(menuWidth, cWidth);
				menuWidth = (menuWidth + widthAdjustment);
			} else {
				menuHeight = (menuHeight + heightAdjustment);
				menuWidth = (menuWidth + widthAdjustment);
			}

			if (option.displayAround == 'cursor') {
				left = cntWin ? e.clientX : e.clientX + $(window).scrollLeft()- cLeft;
				top = cntWin ? e.clientY : e.clientY + $(window).scrollTop() - cTop;
				bottomMenu = top + menuHeight;
				rightMenu = left + menuWidth;
				//max height and width of context menu
				if (bottomMenu > cHeight) {
					if ((top - menuHeight) < 0) {
						if ((bottomMenu - cHeight) < (menuHeight - top)) {
							top = cHeight - menuHeight;
							va = -1 * va;
						} else {
							top = 0;
							va = 0;
						}
					} else {
						top = top - menuHeight;
						va = -1 * va;
					}
				}
				if (rightMenu > cWidth) {
					if ((left - menuWidth) < 0) {
						if ((rightMenu - cWidth) < (menuWidth - left)) {
							left = cWidth - menuWidth;
							ha = -1 * ha;
						} else {
							left = 0;
							ha = 0;
						}
					} else {
						left = left - menuWidth;
						ha = -1 * ha;
					}
				}
			} else if (option.displayAround == 'trigger') {
				var triggerHeight = trigger.outerHeight(true),
					triggerWidth = trigger.outerWidth(true),
					triggerLeft = cntWin ? trigger.offset().left - cObj.scrollLeft() : trigger.offset().left - cLeft,
					triggerTop = cntWin ? trigger.offset().top - cObj.scrollTop() : trigger.offset().top - cTop,
					leftShift = triggerWidth;

				left = triggerLeft + triggerWidth;
				top = triggerTop;

				bottomMenu = top + menuHeight;
				rightMenu = left + menuWidth;
				//max height and width of context menu
				if (bottomMenu > cHeight) {
					if ((top - menuHeight) < 0) {
						if ((bottomMenu - cHeight) < (menuHeight - top)) {
							top = cHeight - menuHeight;
							va = -1 * va;
						} else {
							top = 0;
							va = 0;
						}
					} else {
						top = top - menuHeight + triggerHeight;
						va = -1 * va;
					}
				}
				if (rightMenu > cWidth) {
					if ((left - menuWidth) < 0) {
						if ((rightMenu - cWidth) < (menuWidth - left)) {
							left = cWidth - menuWidth;
							ha = -1 * ha;
							leftShift = -triggerWidth;
						} else {
							left = 0;
							ha = 0;
							leftShift = 0;
						}
					} else {
						left = left - menuWidth - triggerWidth;
						ha = -1 * ha;
						leftShift = -triggerWidth;
					}
				}
				//test end
				if (option.position == 'top') {
					menuHeight = Math.min(menuData.menuHeight, triggerTop);
					top = triggerTop - menuHeight;
					va = verAdjust;
					left = left - leftShift;
				} else if (option.position == 'left') {
					menuWidth = Math.min(menuData.menuWidth, triggerLeft);
					left = triggerLeft - menuWidth;
					ha = horAdjust;
				} else if (option.position == 'bottom') {
					/*!
					 * Dustin modified(2016.02.24) - display the menu upward direction at the bottom of the page
					 */
					if ("actionInGrid" == option.classPrefix) {
						menuHeight = Math.min(menuData.menuHeight, (cHeight - triggerTop - triggerHeight + menuHeight));

						if (bottomMenu > cHeight) {
							top = triggerTop + triggerHeight - menuHeight;
						} else {
							top = triggerTop + triggerHeight;
						}
						va = verAdjust;
						left = left - leftShift;
					} else {
						menuHeight = Math.min(menuData.menuHeight, (cHeight - triggerTop - triggerHeight));
						top = triggerTop + triggerHeight;
						va = verAdjust;
						left = left - leftShift;
					}
//					top = triggerTop + triggerHeight;
//					va = verAdjust;
//					left = left - leftShift;
				} else if (option.position == 'right') {
					menuWidth = Math.min(menuData.menuWidth, (cWidth - triggerLeft - triggerWidth));
					left = triggerLeft + triggerWidth;
					ha = horAdjust;
				}
			}

			//applying css property
			var cssObj = {
				'position' : (cntWin || btChck) ? 'fixed' : 'absolute',
				// Dustin - for effect
//				'display' : 'inline-block',
				"display":"none",
//				'height': '',
//				'width': '',
				'height':option.height,
				'width':option.width,
				'overflow-y': menuHeight != menuData.menuHeight ? 'auto' : 'hidden',
				'overflow-x': menuWidth != menuData.menuWidth ? 'auto' : 'hidden'
			};

			if (option.sizeStyle == 'auto') {
				cssObj.height = menuHeight - outerTopBottom + 'px';
				cssObj.width = menuWidth - outerLeftRight + 'px';
			} else { // Dustin : width adjustment
				cssObj.height = menuHeight + 'px';
				cssObj.width = menuWidth + 'px';
			}

			//to get position from offset parent
			if (option.left != 'auto') {
				left = iMethods.getPxSize(option.left, cWidth);
			}
			if (option.top != 'auto') {
				top = iMethods.getPxSize(option.top, cHeight);
			}
			if (!cntWin) {
				var oParPos = trigger.offsetParent().offset();
				if (btChck) {
					left = left + cLeft - $(window).scrollLeft();
					top = top + cTop - $(window).scrollTop();
				} else {
					left = left - (cLeft - oParPos.left);
					top = top - (cTop - oParPos.top);
				}
			}
			cssObj.left = left + ha + 'px';
			cssObj.top = top + va + 'px';

			/*!
			 * Dustin : open effect here
			 */
//			menu.css(cssObj);
			var effectDuration = option.effectDuration || jsconfig.get("effectDuration");
			/*!
			 * Dustin : border radius
			 */
			if ($.nony.isEmpty(option.borderRadius)) {option.borderRadius = "3px";}

			if (option.displayAround == "cursor") {// main menu
				if ("slide" == option.effect) {
					menu.css(cssObj).corner(option.borderRadius).delay(0).slideDown(effectDuration, function() {
						option.afterOpen.call(this, clbckData, e);
					});
				} else {
					menu.css(cssObj).corner(option.borderRadius).delay(0).fadeIn(effectDuration, function() {
						option.afterOpen.call(this, clbckData, e);
					});
				}
			} else if (option.displayAround == "trigger") {// sub menu
				if ("slide" == option.effect) {
					menu.css(cssObj).corner(option.borderRadius).delay(0).slideDown(effectDuration, function() {
						option.afterOpen.call(this, clbckData, e);
					});
				} else {
					menu.css(cssObj).corner(option.borderRadius).delay(0).fadeIn(effectDuration, function() {
						option.afterOpen.call(this, clbckData, e);
					});
				}
			}
			/*!
			 * Dustin : Logged in User - Header main menu
			 */
			var imgSrc = menu.find("img").prop("src");
			if (!$.nony.isEmpty(imgSrc) && (imgSrc.indexOf("MyProfile") != -1 || imgSrc.indexOf("LogOut") != -1 || imgSrc.indexOf("QM") != -1)) {
				var images, themeId = jsconfig.get("themeId");
				menu.closest('.'+option.classPrefix+'-contextMenu').find("li img").each(function(index) {
					images = $(this).prop("src");
					if (themeId.toUpperCase() == "THEME000" || themeId.toUpperCase() == "THEME002" || themeId.toUpperCase() == "THEME003" || themeId.toUpperCase() == "THEME009") {
						images = $.nony.replace(images, "White", "Black");
					}

					$(this).prop("src", images);
				});
			}

			//to call after open call back
			option.afterOpen.call(this, clbckData, e);

			//to add current menu class
			if (trigger.closest('.'+option.classPrefix+'-contextMenu').length == 0) {
				$('.'+option.classPrefix+'-curMenu').removeClass(option.classPrefix+'-curMenu');
				menu.addClass(option.classPrefix+'-curMenu');
			}

			var dataParm = {
				trigger : trigger,
				menu : menu,
				option : option,
				method : trgrData.method
			};
			$('html').unbind('click', iMethods.clickEvent).click(dataParm, iMethods.clickEvent);
			$(document).unbind('keydown', iMethods.keyEvent).keydown(dataParm, iMethods.keyEvent);
			if (option.winEventClose) {
				$(window).bind('scroll resize', dataParm, iMethods.scrollEvent);
			}
		},

		scrollEvent : function(e) {
			iMethods.closeContextMenu(e.data.option, e.data.trigger, e.data.menu, e);
		},

		clickEvent : function(e) {
			var button = e.data.trigger.get(0);

			if ((button !== e.target) && ($(e.target).closest('.'+option.classPrefix+'-contextMenu').length == 0)) {
				iMethods.closeContextMenu(e.data.option, e.data.trigger, e.data.menu, e);
			}
		},
		keyEvent : function(e) {
			e.preventDefault();
			var menu = e.data.menu,
				option = e.data.option,
				keyCode = e.keyCode;
			// handle cursor keys
			if (keyCode == 27) {
				iMethods.closeContextMenu(option, e.data.trigger, menu, e);
			}
			if (e.data.method == 'menu') {
				var curMenu = $('.'+option.classPrefix+'-curMenu'),
					optList = curMenu.children('li:not(.'+option.classPrefix+'-mDisable)'),
					selected = optList.filter('.'+option.classPrefix+'-mSelected'),
					index = optList.index(selected),
					focusOn = function(elm) {
						iMethods.selectMenu(curMenu, elm);
						var menuData = elm.data(option.classPrefix+'-menuData');
						if (menuData) {
							iMethods.eventHandler.call(elm[0], e);
						}
					}, first = function() {
						focusOn(optList.filter(':first'));
					}, last = function() {
						focusOn(optList.filter(':last'));
					}, next = function() {
						focusOn(optList.filter(':eq(' + (index + 1) + ')'));
					}, prev = function() {
						focusOn(optList.filter(':eq(' + (index - 1) + ')'));
					}, subMenu = function() {
						var menuData = selected.data(option.classPrefix+'-menuData');
						if (menuData) {
							iMethods.eventHandler.call(selected[0], e);
							var selector = menuData.menu;
							selector.addClass(option.classPrefix+'-curMenu');
							curMenu.removeClass(option.classPrefix+'-curMenu');
							curMenu = selector;
							optList = curMenu.children('li:not(.'+option.classPrefix+'-mDisable)');
							selected = optList.filter('.'+option.classPrefix+'-mSelected');
							first();
						}
					}, parMenu = function() {
						var selector = curMenu.data('iw-menuData').trigger;
						var parMenu = selector.closest('.'+option.classPrefix+'-contextMenu');
						if (parMenu.length != 0) {
							curMenu.removeClass(option.classPrefix+'-curMenu').css('display', 'none');
							parMenu.addClass(option.classPrefix+'-curMenu');
					}
				};
				switch (keyCode) {
				case 13:
					selected.click();
					break;
				case 40:
					(index == optList.length - 1 || selected.length == 0) ? first()
							: next();
					break;
				case 38:
					(index == 0 || selected.length == 0) ? last() : prev();
					break;
				case 33:
					first();
					break;
				case 34:
					last();
					break;
				case 37:
					parMenu();
					break;
				case 39:
					subMenu();
					break;
				}
			}
		},
		closeContextMenu : function(option, trigger, menu, e) {
			//unbind all events from top DOM
			$(document).unbind('keydown', iMethods.keyEvent);
			$('html').unbind('click', iMethods.clickEvent);
			$(window).unbind('scroll resize', iMethods.scrollEvent);
			$('.'+option.classPrefix+'-contextMenu').css('display', 'none');

			/*!
			 * Dustin : main menu close effect here
			 */
//			$('.iw-contextMenu').hide();
			var effectDuration = option.effectDuration || jsconfig.get("effectDuration");

			if ("slide" == option.effect) {
				$('.'+option.classPrefix+'-contextMenu').stop().slideUp(effectDuration, function() {});
			} else {
				$('.'+option.classPrefix+'-contextMenu').stop().fadeOut(effectDuration, function() {});
			}

			$(document).focus();

			//call close function
			option.onClose.call(this, {
				trigger : trigger,
				menu : menu
			}, e);
		},
		getPxSize : function(size, of) {
			if (!isNaN(size)) {
				return size;
			}
			if (size.indexOf('%') != -1) {
				return parseInt(size) * of / 100;
			} else {
				return parseInt(size);
			}
		},
		selectMenu : function(menu, elm) {
			//to select the list
			var selected = menu.find('li.'+option.classPrefix+'-mSelected'),
				submenu = selected.find('.'+option.classPrefix+'-contextMenu');
//			if ((submenu.length != 0) && (selected[0] != elm[0])) {
//				submenu.fadeOut(100);
//			}
//			selected.removeClass(option.classPrefix+'-mSelected');
//			elm.addClass(option.classPrefix+'-mSelected');
			//to select the list
			var selected = menu.find('li.'+option.classPrefix+'-mSelected'),
				submenu = selected.find('.'+option.classPrefix+'-contextMenu');
			if ((submenu.length != 0) && (selected[0] != this)) {
				/*!
				 * Dustin : hide sub menu here
				 */
//				submenu.hide(200);
				var effectDuration = option.effectDuration || jsconfig.get("effectDuration");

				if ("slide" == option.effect) {
					submenu.stop().slideUp(effectDuration, function() {});
				} else {
					submenu.stop().fadeOut(effectDuration, function() {});
				}
			}
			selected.removeClass(option.classPrefix+'-mSelected');
			$(this).addClass(option.classPrefix+'-mSelected');

			/*!
			 * Dustin : Logged in User - Header main menu
			 */
			var imgSrc = $(this).find("img").prop("src"), themeId = jsconfig.get("themeId");
			if (!$.nony.isEmpty(imgSrc) && (imgSrc.indexOf("MyProfile") != -1 || imgSrc.indexOf("LogOut") != -1 || imgSrc.indexOf("QM") != -1)) {
				var images;
				$(this).closest('.'+option.classPrefix+'-contextMenu').find("li img").each(function(index) {
					images = $(this).prop("src");
					if (themeId.toUpperCase() == "THEME000" || themeId.toUpperCase() == "THEME002" || themeId.toUpperCase() == "THEME003" || themeId.toUpperCase() == "THEME009") {
						images = $.nony.replace(images, "White", "Black");
					}

					$(this).prop("src", images);
				});

				if (themeId.toUpperCase() == "THEME000" || themeId.toUpperCase() == "THEME002" || themeId.toUpperCase() == "THEME003" || themeId.toUpperCase() == "THEME009") {
					imgSrc = $.nony.replace(imgSrc, "Black", "White");
				}

				$(this).find("img").prop("src", imgSrc);
			}
		},
		menuHover : function(menu) {
			var lastEventTime = Date.now();
			menu.children('li').bind(
				'mouseenter.contextMenu click.contextMenu', function(e) {
				//to make curmenu
				$('.'+option.classPrefix+'-curMenu').removeClass(option.classPrefix+'-curMenu');
				menu.addClass(option.classPrefix+'-curMenu');
				iMethods.selectMenu(menu, $(this));
			});
		},
		createMenuList : function(trgr, selector, option) {
			var baseTrigger = option.baseTrigger,
				randomNum = Math.floor(Math.random() * 10000);
			if ((typeof selector == 'object') && (!selector.nodeType) && (!selector.jquery)) {
				var menuList = $('<ul class="'+option.classPrefix+'-contextMenu '+option.classPrefix+'-created '+option.classPrefix+'-cm-menu" id="'+option.classPrefix+'-contextMenu' + randomNum + '"></ul>');
				$.each(selector, function(index, selObj) {
					var name = selObj.name, fun = selObj.fun
							|| function() {
							}, subMenu = selObj.subMenu, img = selObj.img
							|| '', icon = selObj.icon || '', title = selObj.title
							|| "", className = selObj.className
							|| "", disable = selObj.disable, list = $('<li title="'
							+ title
							+ '" class="'
							+ className
							+ '">' + name + '</li>');

					if (img) {
						list
								.prepend('<img src="'
										+ img
										+ '" align="absmiddle" class="iw-mIcon" />');
					} else if (icon) {
						list
								.prepend('<span align="absmiddle" class="'
										+ "iw-mIcon "
										+ icon
										+ '" />');
					}
					//to add disable
					if (disable) {
						list.addClass('iw-mDisable');
					}

					if (!subMenu) {
						list.bind('click.contextMenu',
								function(e) {
									fun.call(this, {
										trigger : baseTrigger,
										menu : menuList
									}, e);
								});
					}

					//to create sub menu
					menuList.append(list);
					if (subMenu) {
						list
								.addClass('iw-has-submenu')
								.append(
										'<div class="iw-cm-arrow-right" />');
						iMethods.subMenu(list, subMenu,
								baseTrigger, option);
					}
				});

				if (baseTrigger.index(trgr[0]) == -1) {
					trgr.append(menuList);
				} else {
					var par = option.containment == window ? 'body'
							: option.containment;
					$(par).append(menuList);
				}

				iMethods.onOff($('#iw-contextMenu' + randomNum));
				return '#iw-contextMenu' + randomNum;
			} else if ($(selector).length != 0) {
				var element = $(selector);
				element.removeClass('iw-contextMenuCurrent').addClass(
						'iw-contextMenu iw-cm-menu iw-contextMenu' + randomNum)
						.attr('menuId', 'iw-contextMenu' + randomNum).css(
								'display', 'none');

				//to create subMenu
				element.find('ul').each(
						function(index, element) {
							var subMenu = $(this), parent = subMenu
									.parent('li');
							parent.append('<div class="iw-cm-arrow-right" />');
							subMenu.addClass('iw-contextMenuCurrent');
							iMethods.subMenu(parent, '.iw-contextMenuCurrent',
									baseTrigger, option);
						});
				iMethods.onOff($('.iw-contextMenu' + randomNum));
				return '.iw-contextMenu' + randomNum;
			}
		},
		subMenu : function(trigger, selector, baseTrigger, option) {
			trigger.contextMenu('menu', selector, {
				triggerOn : option.subMenuTriggerOn,
				displayAround : 'trigger',
				position : 'auto',
				mouseClick : 'left',
				baseTrigger : baseTrigger,
				containment : option.containment
			});
		},
		onOff : function(menu) {

			menu.find('.iw-mOverlay').remove();
			menu.find('.iw-mDisable').each(
					function() {
						var list = $(this);
						list.append('<div class="iw-mOverlay"/>');
						list.find('.iw-mOverlay').bind('click mouseenter',
								function(event) {
									event.stopPropagation();
								});

					});

		},
		optionOtimizer : function(method, option) {
			if (!option) {
				return;
			}
			if (method == 'menu') {
				if (!option.mouseClick) {
					option.mouseClick = 'right';
				}
			}
			if ((option.mouseClick == 'right') && (option.triggerOn == 'click')) {
				option.triggerOn = 'contextmenu';
			}

			if ($.inArray(option.triggerOn, [ 'hover', 'mouseenter',
					'mouseover', 'mouseleave', 'mouseout', 'focusin',
					'focusout' ]) != -1) {
				option.displayAround = 'trigger';
			}
			return option;
		}
	};
})(jQuery, window, document);