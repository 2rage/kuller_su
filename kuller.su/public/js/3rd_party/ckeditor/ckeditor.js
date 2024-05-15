﻿/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
 */

(function () {
	if (window.CKEDITOR && window.CKEDITOR.dom)
		return;
	if (!window.CKEDITOR)
		window.CKEDITOR = (function () {
			var f = {
				timestamp : 'D03G5XL',
				version : '3.6.6',
				revision : '7689',
				rnd : Math.floor(Math.random() * 900) + 100,
				_ : {},
				status : 'unloaded',
				basePath : (function () {
					var i = window.CKEDITOR_BASEPATH || '';
					if (!i) {
						var j = document.getElementsByTagName('script');
						for (var k = 0; k < j.length; k++) {
							var l = j[k].src.match(/(^|.*[\\\/])ckeditor(?:_basic)?(?:_source)?.js(?:\?.*)?$/i);
							if (l) {
								i = l[1];
								break;
							}
						}
					}
					if (i.indexOf(':/') == -1)
						if (i.indexOf('/') === 0)
							i = location.href.match(/^.*?:\/\/[^\/]*/)[0] + i;
						else
							i = location.href.match(/^[^\?]*\/(?:)/)[0] + i;
					if (!i)
						throw 'The CKEditor installation path could not be automatically detected. Please set the global variable "CKEDITOR_BASEPATH" before creating editor instances.';
					return i;
				})(),
				getUrl : function (i) {
					if (i.indexOf(':/') == -1 && i.indexOf('/') !== 0)
						i = this.basePath + i;
					if (this.timestamp && i.charAt(i.length - 1) != '/' && !/[&?]t=/.test(i))
						i += (i.indexOf('?') >= 0 ? '&' : '?') + 't=' + this.timestamp;
					return i;
				}
			},
			g = window.CKEDITOR_GETURL;
			if (g) {
				var h = f.getUrl;
				f.getUrl = function (i) {
					return g.call(f, i) || h.call(f, i);
				};
			}
			return f;
		})();
	var f = CKEDITOR;
	if (!f.event) {
		f.event = function () {};
		f.event.implementOn = function (g) {
			var h = f.event.prototype;
			for (var i in h) {
				if (g[i] == undefined)
					g[i] = h[i];
			}
		};
		f.event.prototype = (function () {
			var g = function (i) {
				var j = i.getPrivate && i.getPrivate() || i._ || (i._ = {});
				return j.events || (j.events = {});
			},
			h = function (i) {
				this.name = i;
				this.listeners = [];
			};
			h.prototype = {
				getListenerIndex : function (i) {
					for (var j = 0, k = this.listeners; j < k.length; j++) {
						if (k[j].fn == i)
							return j;
					}
					return -1;
				}
			};
			return {
				on : function (i, j, k, l, m) {
					var n = g(this),
					o = n[i] || (n[i] = new h(i));
					if (o.getListenerIndex(j) < 0) {
						var p = o.listeners;
						if (!k)
							k = this;
						if (isNaN(m))
							m = 10;
						var q = this,
						r = function (t, u, v, w) {
							var x = {
								name : i,
								sender : this,
								editor : t,
								data : u,
								listenerData : l,
								stop : v,
								cancel : w,
								removeListener : function () {
									q.removeListener(i, j);
								}
							};
							j.call(k, x);
							return x.data;
						};
						r.fn = j;
						r.priority = m;
						for (var s = p.length - 1; s >= 0; s--) {
							if (p[s].priority <= m) {
								p.splice(s + 1, 0, r);
								return;
							}
						}
						p.unshift(r);
					}
				},
				fire : (function () {
					var i = false,
					j = function () {
						i = true;
					},
					k = false,
					l = function () {
						k = true;
					};
					return function (m, n, o) {
						var p = g(this)[m],
						q = i,
						r = k;
						i = k = false;
						if (p) {
							var s = p.listeners;
							if (s.length) {
								s = s.slice(0);
								for (var t = 0; t < s.length; t++) {
									var u = s[t].call(this, o, n, j, l);
									if (typeof u != 'undefined')
										n = u;
									if (i || k)
										break;
								}
							}
						}
						var v = k || (typeof n == 'undefined' ? false : n);
						i = q;
						k = r;
						return v;
					};
				})(),
				fireOnce : function (i, j, k) {
					var l = this.fire(i, j, k);
					delete g(this)[i];
					return l;
				},
				removeListener : function (i, j) {
					var k = g(this)[i];
					if (k) {
						var l = k.getListenerIndex(j);
						if (l >= 0)
							k.listeners.splice(l, 1);
					}
				},
				hasListeners : function (i) {
					var j = g(this)[i];
					return j && j.listeners.length > 0;
				}
			};
		})();
	}
	if (!f.editor) {
		f.ELEMENT_MODE_NONE = 0;
		f.ELEMENT_MODE_REPLACE = 1;
		f.ELEMENT_MODE_APPENDTO = 2;
		f.editor = function (g, h, i, j) {
			var k = this;
			k._ = {
				instanceConfig : g,
				element : h,
				data : j
			};
			k.elementMode = i || 0;
			f.event.call(k);
			k._init();
		};
		f.editor.replace = function (g, h) {
			var i = g;
			if (typeof i != 'object') {
				i = document.getElementById(g);
				if (i && i.tagName.toLowerCase()in {
					style : 1,
					script : 1,
					base : 1,
					link : 1,
					meta : 1,
					title : 1
				})
					i = null;
				if (!i) {
					var j = 0,
					k = document.getElementsByName(g);
					while ((i = k[j++]) && i.tagName.toLowerCase() != 'textarea') {}
					
				}
				if (!i)
					throw '[CKEDITOR.editor.replace] The element with id or name "' + g + '" was not found.';
			}
			i.style.visibility = 'hidden';
			return new f.editor(h, i, 1);
		};
		f.editor.appendTo = function (g, h, i) {
			var j = g;
			if (typeof j != 'object') {
				j = document.getElementById(g);
				if (!j)
					throw '[CKEDITOR.editor.appendTo] The element with id "' + g + '" was not found.';
			}
			return new f.editor(h, j, 2, i);
		};
		f.editor.prototype = {
			_init : function () {
				var g = f.editor._pending || (f.editor._pending = []);
				g.push(this);
			},
			fire : function (g, h) {
				return f.event.prototype.fire.call(this, g, h, this);
			},
			fireOnce : function (g, h) {
				return f.event.prototype.fireOnce.call(this, g, h, this);
			}
		};
		f.event.implementOn(f.editor.prototype, true);
	}
	if (!f.env)
		f.env = (function () {
			var g = navigator.userAgent.toLowerCase(),
			h = window.opera,
			i = {
				ie : /*@cc_on!@*/
				false,
				opera : !!h && h.version,
				webkit : g.indexOf(' applewebkit/') > -1,
				air : g.indexOf(' adobeair/') > -1,
				mac : g.indexOf('macintosh') > -1,
				quirks : document.compatMode == 'BackCompat',
				mobile : g.indexOf('mobile') > -1,
				iOS : /(ipad|iphone|ipod)/.test(g),
				isCustomDomain : function () {
					if (!this.ie)
						return false;
					var l = document.domain,
					m = window.location.hostname;
					return l != m && l != '[' + m + ']';
				},
				secure : location.protocol == 'https:'
			};
			i.gecko = navigator.product == 'Gecko' && !i.webkit && !i.opera;
			var j = 0;
			if (i.ie) {
				j = parseFloat(g.match(/msie (\d+)/)[1]);
				i.ie8 = !!document.documentMode;
				i.ie8Compat = document.documentMode == 8;
				i.ie9Compat = document.documentMode == 9;
				i.ie7Compat = j == 7 && !document.documentMode || document.documentMode == 7;
				i.ie6Compat = j < 7 || i.quirks;
			}
			if (i.gecko) {
				var k = g.match(/rv:([\d\.]+)/);
				if (k) {
					k = k[1].split('.');
					j = k[0] * 10000 + (k[1] || 0) * 100 +  + (k[2] || 0);
				}
			}
			if (i.opera)
				j = parseFloat(h.version());
			if (i.air)
				j = parseFloat(g.match(/ adobeair\/(\d+)/)[1]);
			if (i.webkit)
				j = parseFloat(g.match(/ applewebkit\/(\d+)/)[1]);
			i.version = j;
			i.isCompatible = i.iOS && j >= 534 || !i.mobile && (i.ie && j >= 6 || i.gecko && j >= 10801 || i.opera && j >= 9.5 || i.air && j >= 1 || i.webkit && j >= 522 || false);
			i.cssClass = 'cke_browser_' + (i.ie ? 'ie' : i.gecko ? 'gecko' : i.opera ? 'opera' : i.webkit ? 'webkit' : 'unknown');
			if (i.quirks)
				i.cssClass += ' cke_browser_quirks';
			if (i.ie) {
				i.cssClass += ' cke_browser_ie' + (i.version < 7 ? '6' : i.version >= 8 ? document.documentMode : '7');
				if (i.quirks)
					i.cssClass += ' cke_browser_iequirks';
				if (document.documentMode && document.documentMode >= 9)
					i.cssClass += ' cke_browser_ie9plus';
			}
			if (i.gecko && j < 10900)
				i.cssClass += ' cke_browser_gecko18';
			if (i.air)
				i.cssClass += ' cke_browser_air';
			return i;
		})();
	var g = f.env;
	var h = g.ie;
	if (f.status == 'unloaded')
		(function () {
			f.event.implementOn(f);
			f.loadFullCore = function () {
				if (f.status != 'basic_ready') {
					f.loadFullCore._load = 1;
					return;
				}
				delete f.loadFullCore;
				var j = document.createElement('script');
				j.type = 'text/javascript';
				j.src = f.basePath + 'ckeditor.js';
				document.getElementsByTagName('head')[0].appendChild(j);
			};
			f.loadFullCoreTimeout = 0;
			f.replaceClass = 'ckeditor';
			f.replaceByClassEnabled = 1;
			var i = function (j, k, l, m) {
				if (g.isCompatible) {
					if (f.loadFullCore)
						f.loadFullCore();
					var n = l(j, k, m);
					f.add(n);
					return n;
				}
				return null;
			};
			f.replace = function (j, k) {
				return i(j, k, f.editor.replace);
			};
			f.appendTo = function (j, k, l) {
				return i(j, k, f.editor.appendTo, l);
			};
			f.add = function (j) {
				var k = this._.pending || (this._.pending = []);
				k.push(j);
			};
			f.replaceAll = function () {
				var j = document.getElementsByTagName('textarea');
				for (var k = 0; k < j.length; k++) {
					var l = null,
					m = j[k];
					if (!m.name && !m.id)
						continue;
					if (typeof arguments[0] == 'string') {
						var n = new RegExp('(?:^|\\s)' + arguments[0] + '(?:$|\\s)');
						if (!n.test(m.className))
							continue;
					} else if (typeof arguments[0] == 'function') {
						l = {};
						if (arguments[0](m, l) === false)
							continue;
					}
					this.replace(m, l);
				}
			};
			(function () {
				var j = function () {
					var k = f.loadFullCore,
					l = f.loadFullCoreTimeout;
					if (f.replaceByClassEnabled)
						f.replaceAll(f.replaceClass);
					f.status = 'basic_ready';
					if (k && k._load)
						k();
					else if (l)
						setTimeout(function () {
							if (f.loadFullCore)
								f.loadFullCore();
						}, l * 1000);
				};
				if (window.addEventListener)
					window.addEventListener('load', j, false);
				else if (window.attachEvent)
					window.attachEvent('onload', j);
			})();
			f.status = 'basic_loaded';
		})();
	f.dom = {};
	var i = f.dom;
	(function () {
		var j = [];
		f.on('reset', function () {
			j = [];
		});
		f.tools = {
			arrayCompare : function (k, l) {
				if (!k && !l)
					return true;
				if (!k || !l || k.length != l.length)
					return false;
				for (var m = 0; m < k.length; m++) {
					if (k[m] != l[m])
						return false;
				}
				return true;
			},
			clone : function (k) {
				var l;
				if (k && k instanceof Array) {
					l = [];
					for (var m = 0; m < k.length; m++)
						l[m] = this.clone(k[m]);
					return l;
				}
				if (k === null || typeof k != 'object' || k instanceof String || k instanceof Number || k instanceof Boolean || k instanceof Date || k instanceof RegExp)
					return k;
				l = new k.constructor();
				for (var n in k) {
					var o = k[n];
					l[n] = this.clone(o);
				}
				return l;
			},
			capitalize : function (k) {
				return k.charAt(0).toUpperCase() + k.substring(1).toLowerCase();
			},
			extend : function (k) {
				var l = arguments.length,
				m,
				n;
				if (typeof(m = arguments[l - 1]) == 'boolean')
					l--;
				else if (typeof(m = arguments[l - 2]) == 'boolean') {
					n = arguments[l - 1];
					l -= 2;
				}
				for (var o = 1; o < l; o++) {
					var p = arguments[o];
					for (var q in p) {
						if (m === true || k[q] == undefined)
							if (!n || q in n)
								k[q] = p[q];
					}
				}
				return k;
			},
			prototypedCopy : function (k) {
				var l = function () {};
				l.prototype = k;
				return new l();
			},
			isArray : function (k) {
				return !!k && k instanceof Array;
			},
			isEmpty : function (k) {
				for (var l in k) {
					if (k.hasOwnProperty(l))
						return false;
				}
				return true;
			},
			cssStyleToDomStyle : (function () {
				var k = document.createElement('div').style,
				l = typeof k.cssFloat != 'undefined' ? 'cssFloat' : typeof k.styleFloat != 'undefined' ? 'styleFloat' : 'float';
				return function (m) {
					if (m == 'float')
						return l;
					else
						return m.replace(/-./g, function (n) {
							return n.substr(1).toUpperCase();
						});
				};
			})(),
			buildStyleHtml : function (k) {
				k = [].concat(k);
				var l,
				m = [];
				for (var n = 0; n < k.length; n++) {
					l = k[n];
					if (/@import|[{}]/.test(l))
						m.push('<style>' + l + '</style>');
					else
						m.push('<link type="text/css" rel=stylesheet href="' + l + '">');
				}
				return m.join('');
			},
			htmlEncode : function (k) {
				var l = function (p) {
					var q = new i.element('span');
					q.setText(p);
					return q.getHtml();
				},
				m = l('\n').toLowerCase() == '<br>' ? function (p) {
					return l(p).replace(/<br>/gi, '\n');
				}
				 : l,
				n = l('>') == '>' ? function (p) {
					return m(p).replace(/>/g, '&gt;');
				}
				 : m,
				o = l('  ') == '&nbsp; ' ? function (p) {
					return n(p).replace(/&nbsp;/g, ' ');
				}
				 : n;
				this.htmlEncode = o;
				return this.htmlEncode(k);
			},
			htmlEncodeAttr : function (k) {
				return k.replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
			},
			getNextNumber : (function () {
				var k = 0;
				return function () {
					return ++k;
				};
			})(),
			getNextId : function () {
				return 'cke_' + this.getNextNumber();
			},
			override : function (k, l) {
				return l(k);
			},
			setTimeout : function (k, l, m, n, o) {
				if (!o)
					o = window;
				if (!m)
					m = o;
				return o.setTimeout(function () {
					if (n)
						k.apply(m, [].concat(n));
					else
						k.apply(m);
				}, l || 0);
			},
			trim : (function () {
				var k = /(?:^[ \t\n\r]+)|(?:[ \t\n\r]+$)/g;
				return function (l) {
					return l.replace(k, '');
				};
			})(),
			ltrim : (function () {
				var k = /^[ \t\n\r]+/g;
				return function (l) {
					return l.replace(k, '');
				};
			})(),
			rtrim : (function () {
				var k = /[ \t\n\r]+$/g;
				return function (l) {
					return l.replace(k, '');
				};
			})(),
			indexOf : Array.prototype.indexOf ? function (k, l) {
				return k.indexOf(l);
			}
			 : function (k, l) {
				for (var m = 0, n = k.length; m < n; m++) {
					if (k[m] === l)
						return m;
				}
				return -1;
			},
			bind : function (k, l) {
				return function () {
					return k.apply(l, arguments);
				};
			},
			createClass : function (k) {
				var l = k.$,
				m = k.base,
				n = k.privates || k._,
				o = k.proto,
				p = k.statics;
				if (n) {
					var q = l;
					l = function () {
						var u = this;
						var r = u._ || (u._ = {});
						for (var s in n) {
							var t = n[s];
							r[s] = typeof t == 'function' ? f.tools.bind(t, u) : t;
						}
						q.apply(u, arguments);
					};
				}
				if (m) {
					l.prototype = this.prototypedCopy(m.prototype);
					l.prototype['constructor'] = l;
					l.prototype.base = function () {
						this.base = m.prototype.base;
						m.apply(this, arguments);
						this.base = arguments.callee;
					};
				}
				if (o)
					this.extend(l.prototype, o, true);
				if (p)
					this.extend(l, p, true);
				return l;
			},
			addFunction : function (k, l) {
				return j.push(function () {
					return k.apply(l || this, arguments);
				}) - 1;
			},
			removeFunction : function (k) {
				j[k] = null;
			},
			callFunction : function (k) {
				var l = j[k];
				return l && l.apply(window, Array.prototype.slice.call(arguments, 1));
			},
			cssLength : (function () {
				return function (k) {
					return k + (!k || isNaN(Number(k)) ? '' : 'px');
				};
			})(),
			convertToPx : (function () {
				var k;
				return function (l) {
					if (!k) {
						k = i.element.createFromHtml('<div style="position:absolute;left:-9999px;top:-9999px;margin:0px;padding:0px;border:0px;"></div>', f.document);
						f.document.getBody().append(k);
					}
					if (!/%$/.test(l)) {
						k.setStyle('width', l);
						return k.$.clientWidth;
					}
					return l;
				};
			})(),
			repeat : function (k, l) {
				return new Array(l + 1).join(k);
			},
			tryThese : function () {
				var k;
				for (var l = 0, m = arguments.length; l < m; l++) {
					var n = arguments[l];
					try {
						k = n();
						break;
					} catch (o) {}
					
				}
				return k;
			},
			genKey : function () {
				return Array.prototype.slice.call(arguments).join('-');
			},
			normalizeCssText : function (k, l) {
				var m = [],
				n,
				o = f.tools.parseCssText(k, true, l);
				for (n in o)
					m.push(n + ':' + o[n]);
				m.sort();
				return m.length ? m.join(';') + ';' : '';
			},
			convertRgbToHex : function (k) {
				return k.replace(/(?:rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\))/gi, function (l, m, n, o) {
					var p = [m, n, o];
					for (var q = 0; q < 3; q++)
						p[q] = ('0' + parseInt(p[q], 10).toString(16)).slice(-2);
					return '#' + p.join('');
				});
			},
			parseCssText : function (k, l, m) {
				var n = {};
				if (m) {
					var o = new i.element('span');
					o.setAttribute('style', k);
					k = f.tools.convertRgbToHex(o.getAttribute('style') || '');
				}
				if (!k || k == ';')
					return n;
				k.replace(/&quot;/g, '"').replace(/\s*([^:;\s]+)\s*:\s*([^;]+)\s*(?=;|$)/g, function (p, q, r) {
					if (l) {
						q = q.toLowerCase();
						if (q == 'font-family')
							r = r.toLowerCase().replace(/["']/g, '').replace(/\s*,\s*/g, ',');
						r = f.tools.trim(r);
					}
					n[q] = r;
				});
				return n;
			}
		};
	})();
	var j = f.tools;
	f.dtd = (function () {
		var k = j.extend,
		l = {
			isindex : 1,
			fieldset : 1
		},
		m = {
			input : 1,
			button : 1,
			select : 1,
			textarea : 1,
			label : 1
		},
		n = k({
				a : 1
			}, m),
		o = k({
				iframe : 1
			}, n),
		p = {
			hr : 1,
			ul : 1,
			menu : 1,
			div : 1,
			section : 1,
			header : 1,
			footer : 1,
			nav : 1,
			article : 1,
			aside : 1,
			figure : 1,
			dialog : 1,
			hgroup : 1,
			mark : 1,
			time : 1,
			meter : 1,
			command : 1,
			keygen : 1,
			output : 1,
			progress : 1,
			audio : 1,
			video : 1,
			details : 1,
			datagrid : 1,
			datalist : 1,
			blockquote : 1,
			noscript : 1,
			table : 1,
			center : 1,
			address : 1,
			dir : 1,
			pre : 1,
			h5 : 1,
			dl : 1,
			h4 : 1,
			noframes : 1,
			h6 : 1,
			ol : 1,
			h1 : 1,
			h3 : 1,
			h2 : 1
		},
		q = {
			ins : 1,
			del : 1,
			script : 1,
			style : 1
		},
		r = k({
				b : 1,
				acronym : 1,
				bdo : 1,
				'var' : 1,
				'#' : 1,
				abbr : 1,
				code : 1,
				br : 1,
				i : 1,
				cite : 1,
				kbd : 1,
				u : 1,
				strike : 1,
				s : 1,
				tt : 1,
				strong : 1,
				q : 1,
				samp : 1,
				em : 1,
				dfn : 1,
				span : 1,
				wbr : 1
			}, q),
		s = k({
				sub : 1,
				img : 1,
				object : 1,
				sup : 1,
				basefont : 1,
				map : 1,
				applet : 1,
				font : 1,
				big : 1,
				small : 1,
				mark : 1
			}, r),
		t = k({
				p : 1
			}, s),
		u = k({
				iframe : 1
			}, s, m),
		v = {
			img : 1,
			noscript : 1,
			br : 1,
			kbd : 1,
			center : 1,
			button : 1,
			basefont : 1,
			h5 : 1,
			h4 : 1,
			samp : 1,
			h6 : 1,
			ol : 1,
			h1 : 1,
			h3 : 1,
			h2 : 1,
			form : 1,
			font : 1,
			'#' : 1,
			select : 1,
			menu : 1,
			ins : 1,
			abbr : 1,
			label : 1,
			code : 1,
			table : 1,
			script : 1,
			cite : 1,
			input : 1,
			iframe : 1,
			strong : 1,
			textarea : 1,
			noframes : 1,
			big : 1,
			small : 1,
			span : 1,
			hr : 1,
			sub : 1,
			bdo : 1,
			'var' : 1,
			div : 1,
			section : 1,
			header : 1,
			footer : 1,
			nav : 1,
			article : 1,
			aside : 1,
			figure : 1,
			dialog : 1,
			hgroup : 1,
			mark : 1,
			time : 1,
			meter : 1,
			menu : 1,
			command : 1,
			keygen : 1,
			output : 1,
			progress : 1,
			audio : 1,
			video : 1,
			details : 1,
			datagrid : 1,
			datalist : 1,
			object : 1,
			sup : 1,
			strike : 1,
			dir : 1,
			map : 1,
			dl : 1,
			applet : 1,
			del : 1,
			isindex : 1,
			fieldset : 1,
			ul : 1,
			b : 1,
			acronym : 1,
			a : 1,
			blockquote : 1,
			i : 1,
			u : 1,
			s : 1,
			tt : 1,
			address : 1,
			q : 1,
			pre : 1,
			p : 1,
			em : 1,
			dfn : 1
		},
		w = k({
				a : 1
			}, u),
		x = {
			tr : 1
		},
		y = {
			'#' : 1
		},
		z = k({
				param : 1
			}, v),
		A = k({
				form : 1
			}, l, o, p, t),
		B = {
			li : 1
		},
		C = {
			style : 1,
			script : 1
		},
		D = {
			base : 1,
			link : 1,
			meta : 1,
			title : 1
		},
		E = k(D, C),
		F = {
			head : 1,
			body : 1
		},
		G = {
			html : 1
		},
		H = {
			address : 1,
			blockquote : 1,
			center : 1,
			dir : 1,
			div : 1,
			section : 1,
			header : 1,
			footer : 1,
			nav : 1,
			article : 1,
			aside : 1,
			figure : 1,
			dialog : 1,
			hgroup : 1,
			time : 1,
			meter : 1,
			menu : 1,
			command : 1,
			keygen : 1,
			output : 1,
			progress : 1,
			audio : 1,
			video : 1,
			details : 1,
			datagrid : 1,
			datalist : 1,
			dl : 1,
			fieldset : 1,
			form : 1,
			h1 : 1,
			h2 : 1,
			h3 : 1,
			h4 : 1,
			h5 : 1,
			h6 : 1,
			hr : 1,
			isindex : 1,
			noframes : 1,
			ol : 1,
			p : 1,
			pre : 1,
			table : 1,
			ul : 1
		};
		return {
			$nonBodyContent : k(G, F, D),
			$block : H,
			$blockLimit : {
				body : 1,
				div : 1,
				section : 1,
				header : 1,
				footer : 1,
				nav : 1,
				article : 1,
				aside : 1,
				figure : 1,
				dialog : 1,
				hgroup : 1,
				time : 1,
				meter : 1,
				menu : 1,
				command : 1,
				keygen : 1,
				output : 1,
				progress : 1,
				audio : 1,
				video : 1,
				details : 1,
				datagrid : 1,
				datalist : 1,
				td : 1,
				th : 1,
				caption : 1,
				form : 1
			},
			$inline : w,
			$body : k({
				script : 1,
				style : 1
			}, H),
			$cdata : {
				script : 1,
				style : 1
			},
			$empty : {
				area : 1,
				base : 1,
				br : 1,
				col : 1,
				hr : 1,
				img : 1,
				input : 1,
				link : 1,
				meta : 1,
				param : 1,
				wbr : 1
			},
			$listItem : {
				dd : 1,
				dt : 1,
				li : 1
			},
			$list : {
				ul : 1,
				ol : 1,
				dl : 1
			},
			$nonEditable : {
				applet : 1,
				button : 1,
				embed : 1,
				iframe : 1,
				map : 1,
				object : 1,
				option : 1,
				script : 1,
				textarea : 1,
				param : 1,
				audio : 1,
				video : 1
			},
			$captionBlock : {
				caption : 1,
				legend : 1
			},
			$removeEmpty : {
				abbr : 1,
				acronym : 1,
				address : 1,
				b : 1,
				bdo : 1,
				big : 1,
				cite : 1,
				code : 1,
				del : 1,
				dfn : 1,
				em : 1,
				font : 1,
				i : 1,
				ins : 1,
				label : 1,
				kbd : 1,
				q : 1,
				s : 1,
				samp : 1,
				small : 1,
				span : 1,
				strike : 1,
				strong : 1,
				sub : 1,
				sup : 1,
				tt : 1,
				u : 1,
				'var' : 1,
				mark : 1
			},
			$tabIndex : {
				a : 1,
				area : 1,
				button : 1,
				input : 1,
				object : 1,
				select : 1,
				textarea : 1
			},
			$tableContent : {
				caption : 1,
				col : 1,
				colgroup : 1,
				tbody : 1,
				td : 1,
				tfoot : 1,
				th : 1,
				thead : 1,
				tr : 1
			},
			html : F,
			head : E,
			style : y,
			script : y,
			body : A,
			base : {},
			link : {},
			meta : {},
			title : y,
			col : {},
			tr : {
				td : 1,
				th : 1
			},
			img : {},
			colgroup : {
				col : 1
			},
			noscript : A,
			td : A,
			br : {},
			wbr : {},
			th : A,
			center : A,
			kbd : w,
			button : k(t, p),
			basefont : {},
			h5 : w,
			h4 : w,
			samp : w,
			h6 : w,
			ol : B,
			h1 : w,
			h3 : w,
			option : y,
			h2 : w,
			form : k(l, o, p, t),
			select : {
				optgroup : 1,
				option : 1
			},
			font : w,
			ins : w,
			menu : B,
			abbr : w,
			label : w,
			table : {
				thead : 1,
				col : 1,
				tbody : 1,
				tr : 1,
				colgroup : 1,
				caption : 1,
				tfoot : 1
			},
			code : w,
			tfoot : x,
			cite : w,
			li : A,
			input : {},
			iframe : A,
			strong : w,
			textarea : y,
			noframes : A,
			big : w,
			small : w,
			span : w,
			hr : {},
			dt : w,
			sub : w,
			optgroup : {
				option : 1
			},
			param : {},
			bdo : w,
			'var' : w,
			div : A,
			object : z,
			sup : w,
			dd : A,
			strike : w,
			area : {},
			dir : B,
			map : k({
				area : 1,
				form : 1,
				p : 1
			}, l, q, p),
			applet : z,
			dl : {
				dt : 1,
				dd : 1
			},
			del : w,
			isindex : {},
			fieldset : k({
				legend : 1
			}, v),
			thead : x,
			ul : B,
			acronym : w,
			b : w,
			a : u,
			blockquote : A,
			caption : w,
			i : w,
			u : w,
			tbody : x,
			s : w,
			address : k(o, t),
			tt : w,
			legend : w,
			q : w,
			pre : k(r, n),
			p : w,
			em : w,
			dfn : w,
			section : A,
			header : A,
			footer : A,
			nav : A,
			article : A,
			aside : A,
			figure : A,
			dialog : A,
			hgroup : A,
			mark : w,
			time : w,
			meter : w,
			menu : w,
			command : w,
			keygen : w,
			output : w,
			progress : z,
			audio : z,
			video : z,
			details : z,
			datagrid : z,
			datalist : z
		};
	})();
	var k = f.dtd;
	i.event = function (l) {
		this.$ = l;
	};
	i.event.prototype = {
		getKey : function () {
			return this.$.keyCode || this.$.which;
		},
		getKeystroke : function () {
			var m = this;
			var l = m.getKey();
			if (m.$.ctrlKey || m.$.metaKey)
				l += 1000;
			if (m.$.shiftKey)
				l += 2000;
			if (m.$.altKey)
				l += 4000;
			return l;
		},
		preventDefault : function (l) {
			var m = this.$;
			if (m.preventDefault)
				m.preventDefault();
			else
				m.returnValue = false;
			if (l)
				this.stopPropagation();
		},
		stopPropagation : function () {
			var l = this.$;
			if (l.stopPropagation)
				l.stopPropagation();
			else
				l.cancelBubble = true;
		},
		getTarget : function () {
			var l = this.$.target || this.$.srcElement;
			return l ? new i.node(l) : null;
		},
		getPageOffset : function () {
			var o = this;
			var l = o.getTarget().getDocument().$,
			m = o.$.pageX || o.$.clientX + (l.documentElement.scrollLeft || l.body.scrollLeft),
			n = o.$.pageY || o.$.clientY + (l.documentElement.scrollTop || l.body.scrollTop);
			return {
				x : m,
				y : n
			};
		}
	};
	f.CTRL = 1114112;
	f.SHIFT = 2228224;
	f.ALT = 4456448;
	i.domObject = function (l) {
		if (l)
			this.$ = l;
	};
	i.domObject.prototype = (function () {
		var l = function (m, n) {
			return function (o) {
				if (typeof f != 'undefined')
					m.fire(n, new i.event(o));
			};
		};
		return {
			getPrivate : function () {
				var m;
				if (!(m = this.getCustomData('_')))
					this.setCustomData('_', m = {});
				return m;
			},
			on : function (m) {
				var p = this;
				var n = p.getCustomData('_cke_nativeListeners');
				if (!n) {
					n = {};
					p.setCustomData('_cke_nativeListeners', n);
				}
				if (!n[m]) {
					var o = n[m] = l(p, m);
					if (p.$.addEventListener)
						p.$.addEventListener(m, o, !!f.event.useCapture);
					else if (p.$.attachEvent)
						p.$.attachEvent('on' + m, o);
				}
				return f.event.prototype.on.apply(p, arguments);
			},
			removeListener : function (m) {
				var p = this;
				f.event.prototype.removeListener.apply(p, arguments);
				if (!p.hasListeners(m)) {
					var n = p.getCustomData('_cke_nativeListeners'),
					o = n && n[m];
					if (o) {
						if (p.$.removeEventListener)
							p.$.removeEventListener(m, o, false);
						else if (p.$.detachEvent)
							p.$.detachEvent('on' + m, o);
						delete n[m];
					}
				}
			},
			removeAllListeners : function () {
				var p = this;
				var m = p.getCustomData('_cke_nativeListeners');
				for (var n in m) {
					var o = m[n];
					if (p.$.detachEvent)
						p.$.detachEvent('on' + n, o);
					else if (p.$.removeEventListener)
						p.$.removeEventListener(n, o, false);
					delete m[n];
				}
			}
		};
	})();
	(function (l) {
		var m = {};
		f.on('reset', function () {
			m = {};
		});
		l.equals = function (n) {
			return n && n.$ === this.$;
		};
		l.setCustomData = function (n, o) {
			var p = this.getUniqueId(),
			q = m[p] || (m[p] = {});
			q[n] = o;
			return this;
		};
		l.getCustomData = function (n) {
			var o = this.$['data-cke-expando'],
			p = o && m[o];
			return p && p[n];
		};
		l.removeCustomData = function (n) {
			var o = this.$['data-cke-expando'],
			p = o && m[o],
			q = p && p[n];
			if (typeof q != 'undefined')
				delete p[n];
			return q || null;
		};
		l.clearCustomData = function () {
			this.removeAllListeners();
			var n = this.$['data-cke-expando'];
			n && delete m[n];
		};
		l.getUniqueId = function () {
			return this.$['data-cke-expando'] || (this.$['data-cke-expando'] = j.getNextNumber());
		};
		f.event.implementOn(l);
	})(i.domObject.prototype);
	i.window = function (l) {
		i.domObject.call(this, l);
	};
	i.window.prototype = new i.domObject();
	j.extend(i.window.prototype, {
		focus : function () {
			if (g.webkit && this.$.parent)
				this.$.parent.focus();
			this.$.focus();
		},
		getViewPaneSize : function () {
			var l = this.$.document,
			m = l.compatMode == 'CSS1Compat';
			return {
				width : (m ? l.documentElement.clientWidth : l.body.clientWidth) || 0,
				height : (m ? l.documentElement.clientHeight : l.body.clientHeight) || 0
			};
		},
		getScrollPosition : function () {
			var l = this.$;
			if ('pageXOffset' in l)
				return {
					x : l.pageXOffset || 0,
					y : l.pageYOffset || 0
				};
			else {
				var m = l.document;
				return {
					x : m.documentElement.scrollLeft || m.body.scrollLeft || 0,
					y : m.documentElement.scrollTop || m.body.scrollTop || 0
				};
			}
		}
	});
	i.document = function (l) {
		i.domObject.call(this, l);
	};
	var l = i.document;
	l.prototype = new i.domObject();
	j.extend(l.prototype, {
		appendStyleSheet : function (m) {
			if (this.$.createStyleSheet)
				this.$.createStyleSheet(m);
			else {
				var n = new i.element('link');
				n.setAttributes({
					rel : 'stylesheet',
					type : 'text/css',
					href : m
				});
				this.getHead().append(n);
			}
		},
		appendStyleText : function (m) {
			var p = this;
			if (p.$.createStyleSheet) {
				var n = p.$.createStyleSheet('');
				n.cssText = m;
			} else {
				var o = new i.element('style', p);
				o.append(new i.text(m, p));
				p.getHead().append(o);
			}
		},
		createElement : function (m, n) {
			var o = new i.element(m, this);
			if (n) {
				if (n.attributes)
					o.setAttributes(n.attributes);
				if (n.styles)
					o.setStyles(n.styles);
			}
			return o;
		},
		createText : function (m) {
			return new i.text(m, this);
		},
		focus : function () {
			this.getWindow().focus();
		},
		getById : function (m) {
			var n = this.$.getElementById(m);
			return n ? new i.element(n) : null;
		},
		getByAddress : function (m, n) {
			var o = this.$.documentElement;
			for (var p = 0; o && p < m.length; p++) {
				var q = m[p];
				if (!n) {
					o = o.childNodes[q];
					continue;
				}
				var r = -1;
				for (var s = 0; s < o.childNodes.length; s++) {
					var t = o.childNodes[s];
					if (n === true && t.nodeType == 3 && t.previousSibling && t.previousSibling.nodeType == 3)
						continue;
					r++;
					if (r == q) {
						o = t;
						break;
					}
				}
			}
			return o ? new i.node(o) : null;
		},
		getElementsByTag : function (m, n) {
			if (!(h && !(document.documentMode > 8)) && n)
				m = n + ':' + m;
			return new i.nodeList(this.$.getElementsByTagName(m));
		},
		getHead : function () {
			var m = this.$.getElementsByTagName('head')[0];
			if (!m)
				m = this.getDocumentElement().append(new i.element('head'), true);
			else
				m = new i.element(m);
			return (this.getHead = function () {
				return m;
			})();
		},
		getBody : function () {
			var m = new i.element(this.$.body);
			return (this.getBody = function () {
				return m;
			})();
		},
		getDocumentElement : function () {
			var m = new i.element(this.$.documentElement);
			return (this.getDocumentElement = function () {
				return m;
			})();
		},
		getWindow : function () {
			var m = new i.window(this.$.parentWindow || this.$.defaultView);
			return (this.getWindow = function () {
				return m;
			})();
		},
		write : function (m) {
			var n = this;
			n.$.open('text/html', 'replace');
			g.isCustomDomain() && (n.$.domain = document.domain);
			n.$.write(m);
			n.$.close();
		}
	});
	i.node = function (m) {
		if (m) {
			var n = m.nodeType == 9 ? 'document' : m.nodeType == 1 ? 'element' : m.nodeType == 3 ? 'text' : m.nodeType == 8 ? 'comment' : 'domObject';
			return new i[n](m);
		}
		return this;
	};
	i.node.prototype = new i.domObject();
	f.NODE_ELEMENT = 1;
	f.NODE_DOCUMENT = 9;
	f.NODE_TEXT = 3;
	f.NODE_COMMENT = 8;
	f.NODE_DOCUMENT_FRAGMENT = 11;
	f.POSITION_IDENTICAL = 0;
	f.POSITION_DISCONNECTED = 1;
	f.POSITION_FOLLOWING = 2;
	f.POSITION_PRECEDING = 4;
	f.POSITION_IS_CONTAINED = 8;
	f.POSITION_CONTAINS = 16;
	j.extend(i.node.prototype, {
		appendTo : function (m, n) {
			m.append(this, n);
			return m;
		},
		clone : function (m, n) {
			var o = this.$.cloneNode(m),
			p = function (q) {
				if (q.nodeType != 1)
					return;
				if (!n)
					q.removeAttribute('id', false);
				q['data-cke-expando'] = undefined;
				if (m) {
					var r = q.childNodes;
					for (var s = 0; s < r.length; s++)
						p(r[s]);
				}
			};
			p(o);
			return new i.node(o);
		},
		hasPrevious : function () {
			return !!this.$.previousSibling;
		},
		hasNext : function () {
			return !!this.$.nextSibling;
		},
		insertAfter : function (m) {
			m.$.parentNode.insertBefore(this.$, m.$.nextSibling);
			return m;
		},
		insertBefore : function (m) {
			m.$.parentNode.insertBefore(this.$, m.$);
			return m;
		},
		insertBeforeMe : function (m) {
			this.$.parentNode.insertBefore(m.$, this.$);
			return m;
		},
		getAddress : function (m) {
			var n = [],
			o = this.getDocument().$.documentElement,
			p = this.$;
			while (p && p != o) {
				var q = p.parentNode;
				if (q)
					n.unshift(this.getIndex.call({
							$ : p
						}, m));
				p = q;
			}
			return n;
		},
		getDocument : function () {
			return new l(this.$.ownerDocument || this.$.parentNode.ownerDocument);
		},
		getIndex : function (m) {
			var n = this.$,
			o = 0;
			while (n = n.previousSibling) {
				if (m && n.nodeType == 3 && (!n.nodeValue.length || n.previousSibling && n.previousSibling.nodeType == 3))
					continue;
				o++;
			}
			return o;
		},
		getNextSourceNode : function (m, n, o) {
			if (o && !o.call) {
				var p = o;
				o = function (s) {
					return !s.equals(p);
				};
			}
			var q = !m && this.getFirst && this.getFirst(),
			r;
			if (!q) {
				if (this.type == 1 && o && o(this, true) === false)
					return null;
				q = this.getNext();
			}
			while (!q && (r = (r || this).getParent())) {
				if (o && o(r, true) === false)
					return null;
				q = r.getNext();
			}
			if (!q)
				return null;
			if (o && o(q) === false)
				return null;
			if (n && n != q.type)
				return q.getNextSourceNode(false, n, o);
			return q;
		},
		getPreviousSourceNode : function (m, n, o) {
			if (o && !o.call) {
				var p = o;
				o = function (s) {
					return !s.equals(p);
				};
			}
			var q = !m && this.getLast && this.getLast(),
			r;
			if (!q) {
				if (this.type == 1 && o && o(this, true) === false)
					return null;
				q = this.getPrevious();
			}
			while (!q && (r = (r || this).getParent())) {
				if (o && o(r, true) === false)
					return null;
				q = r.getPrevious();
			}
			if (!q)
				return null;
			if (o && o(q) === false)
				return null;
			if (n && q.type != n)
				return q.getPreviousSourceNode(false, n, o);
			return q;
		},
		getPrevious : function (m) {
			var n = this.$,
			o;
			do {
				n = n.previousSibling;
				o = n && n.nodeType != 10 && new i.node(n);
			} while (o && m && !m(o))
			return o;
		},
		getNext : function (m) {
			var n = this.$,
			o;
			do {
				n = n.nextSibling;
				o = n && new i.node(n);
			} while (o && m && !m(o))
			return o;
		},
		getParent : function () {
			var m = this.$.parentNode;
			return m && m.nodeType == 1 ? new i.node(m) : null;
		},
		getParents : function (m) {
			var n = this,
			o = [];
			do
				o[m ? 'push' : 'unshift'](n);
			while (n = n.getParent())
			return o;
		},
		getCommonAncestor : function (m) {
			var o = this;
			if (m.equals(o))
				return o;
			if (m.contains && m.contains(o))
				return m;
			var n = o.contains ? o : o.getParent();
			do {
				if (n.contains(m))
					return n;
			} while (n = n.getParent())
			return null;
		},
		getPosition : function (m) {
			var n = this.$,
			o = m.$;
			if (n.compareDocumentPosition)
				return n.compareDocumentPosition(o);
			if (n == o)
				return 0;
			if (this.type == 1 && m.type == 1) {
				if (n.contains) {
					if (n.contains(o))
						return 16 + 4;
					if (o.contains(n))
						return 8 + 2;
				}
				if ('sourceIndex' in n)
					return n.sourceIndex < 0 || o.sourceIndex < 0 ? 1 : n.sourceIndex < o.sourceIndex ? 4 : 2;
			}
			var p = this.getAddress(),
			q = m.getAddress(),
			r = Math.min(p.length, q.length);
			for (var s = 0; s <= r - 1; s++) {
				if (p[s] != q[s]) {
					if (s < r)
						return p[s] < q[s] ? 4 : 2;
					break;
				}
			}
			return p.length < q.length ? 16 + 4 : 8 + 2;
		},
		getAscendant : function (m, n) {
			var o = this.$,
			p;
			if (!n)
				o = o.parentNode;
			while (o) {
				if (o.nodeName && (p = o.nodeName.toLowerCase(), typeof m == 'string' ? p == m : p in m))
					return new i.node(o);
				o = o.parentNode;
			}
			return null;
		},
		hasAscendant : function (m, n) {
			var o = this.$;
			if (!n)
				o = o.parentNode;
			while (o) {
				if (o.nodeName && o.nodeName.toLowerCase() == m)
					return true;
				o = o.parentNode;
			}
			return false;
		},
		move : function (m, n) {
			m.append(this.remove(), n);
		},
		remove : function (m) {
			var n = this.$,
			o = n.parentNode;
			if (o) {
				if (m)
					for (var p; p = n.firstChild; )
						o.insertBefore(n.removeChild(p), n);
				o.removeChild(n);
			}
			return this;
		},
		replace : function (m) {
			this.insertBefore(m);
			m.remove();
		},
		trim : function () {
			this.ltrim();
			this.rtrim();
		},
		ltrim : function () {
			var p = this;
			var m;
			while (p.getFirst && (m = p.getFirst())) {
				if (m.type == 3) {
					var n = j.ltrim(m.getText()),
					o = m.getLength();
					if (!n) {
						m.remove();
						continue;
					} else if (n.length < o) {
						m.split(o - n.length);
						p.$.removeChild(p.$.firstChild);
					}
				}
				break;
			}
		},
		rtrim : function () {
			var p = this;
			var m;
			while (p.getLast && (m = p.getLast())) {
				if (m.type == 3) {
					var n = j.rtrim(m.getText()),
					o = m.getLength();
					if (!n) {
						m.remove();
						continue;
					} else if (n.length < o) {
						m.split(n.length);
						p.$.lastChild.parentNode.removeChild(p.$.lastChild);
					}
				}
				break;
			}
			if (!h && !g.opera) {
				m = p.$.lastChild;
				if (m && m.type == 1 && m.nodeName.toLowerCase() == 'br')
					m.parentNode.removeChild(m);
			}
		},
		isReadOnly : function () {
			var m = this;
			if (this.type != 1)
				m = this.getParent();
			if (m && typeof m.$.isContentEditable != 'undefined')
				return !(m.$.isContentEditable || m.data('cke-editable'));
			else {
				var n = m;
				while (n) {
					if (n.is('body') || !!n.data('cke-editable'))
						break;
					if (n.getAttribute('contentEditable') == 'false')
						return true;
					else if (n.getAttribute('contentEditable') == 'true')
						break;
					n = n.getParent();
				}
				return false;
			}
		}
	});
	i.nodeList = function (m) {
		this.$ = m;
	};
	i.nodeList.prototype = {
		count : function () {
			return this.$.length;
		},
		getItem : function (m) {
			var n = this.$[m];
			return n ? new i.node(n) : null;
		}
	};
	i.element = function (m, n) {
		if (typeof m == 'string')
			m = (n ? n.$ : document).createElement(m);
		i.domObject.call(this, m);
	};
	var m = i.element;
	m.get = function (n) {
		return n && (n.$ ? n : new m(n));
	};
	m.prototype = new i.node();
	m.createFromHtml = function (n, o) {
		var p = new m('div', o);
		p.setHtml(n);
		return p.getFirst().remove();
	};
	m.setMarker = function (n, o, p, q) {
		var r = o.getCustomData('list_marker_id') || o.setCustomData('list_marker_id', j.getNextNumber()).getCustomData('list_marker_id'),
		s = o.getCustomData('list_marker_names') || o.setCustomData('list_marker_names', {}).getCustomData('list_marker_names');
		n[r] = o;
		s[p] = 1;
		return o.setCustomData(p, q);
	};
	m.clearAllMarkers = function (n) {
		for (var o in n)
			m.clearMarkers(n, n[o], 1);
	};
	m.clearMarkers = function (n, o, p) {
		var q = o.getCustomData('list_marker_names'),
		r = o.getCustomData('list_marker_id');
		for (var s in q)
			o.removeCustomData(s);
		o.removeCustomData('list_marker_names');
		if (p) {
			o.removeCustomData('list_marker_id');
			delete n[r];
		}
	};
	(function () {
		j.extend(m.prototype, {
			type : 1,
			addClass : function (q) {
				var r = this.$.className;
				if (r) {
					var s = new RegExp('(?:^|\\s)' + q + '(?:\\s|$)', '');
					if (!s.test(r))
						r += ' ' + q;
				}
				this.$.className = r || q;
			},
			removeClass : function (q) {
				var r = this.getAttribute('class');
				if (r) {
					var s = new RegExp('(?:^|\\s+)' + q + '(?=\\s|$)', 'i');
					if (s.test(r)) {
						r = r.replace(s, '').replace(/^\s+/, '');
						if (r)
							this.setAttribute('class', r);
						else
							this.removeAttribute('class');
					}
				}
			},
			hasClass : function (q) {
				var r = new RegExp('(?:^|\\s+)' + q + '(?=\\s|$)', '');
				return r.test(this.getAttribute('class'));
			},
			append : function (q, r) {
				var s = this;
				if (typeof q == 'string')
					q = s.getDocument().createElement(q);
				if (r)
					s.$.insertBefore(q.$, s.$.firstChild);
				else
					s.$.appendChild(q.$);
				return q;
			},
			appendHtml : function (q) {
				var s = this;
				if (!s.$.childNodes.length)
					s.setHtml(q);
				else {
					var r = new m('div', s.getDocument());
					r.setHtml(q);
					r.moveChildren(s);
				}
			},
			appendText : function (q) {
				if (this.$.text != undefined)
					this.$.text += q;
				else
					this.append(new i.text(q));
			},
			appendBogus : function () {
				var s = this;
				var q = s.getLast();
				while (q && q.type == 3 && !j.rtrim(q.getText()))
					q = q.getPrevious();
				if (!q || !q.is || !q.is('br')) {
					var r = g.opera ? s.getDocument().createText('') : s.getDocument().createElement('br');
					g.gecko && r.setAttribute('type', '_moz');
					s.append(r);
				}
			},
			breakParent : function (q) {
				var t = this;
				var r = new i.range(t.getDocument());
				r.setStartAfter(t);
				r.setEndAfter(q);
				var s = r.extractContents();
				r.insertNode(t.remove());
				s.insertAfterNode(t);
			},
			contains : h || g.webkit ? function (q) {
				var r = this.$;
				return q.type != 1 ? r.contains(q.getParent().$) : r != q.$ && r.contains(q.$);
			}
			 : function (q) {
				return !!(this.$.compareDocumentPosition(q.$) & 16);
			},
			focus : (function () {
				function q() {
					try {
						this.$.focus();
					} catch (r) {}
					
				};
				return function (r) {
					if (r)
						j.setTimeout(q, 100, this);
					else
						q.call(this);
				};
			})(),
			getHtml : function () {
				var q = this.$.innerHTML;
				return h ? q.replace(/<\?[^>]*>/g, '') : q;
			},
			getOuterHtml : function () {
				var r = this;
				if (r.$.outerHTML)
					return r.$.outerHTML.replace(/<\?[^>]*>/, '');
				var q = r.$.ownerDocument.createElement('div');
				q.appendChild(r.$.cloneNode(true));
				return q.innerHTML;
			},
			setHtml : function (q) {
				return this.$.innerHTML = q;
			},
			setText : function (q) {
				m.prototype.setText = this.$.innerText != undefined ? function (r) {
					return this.$.innerText = r;
				}
				 : function (r) {
					return this.$.textContent = r;
				};
				return this.setText(q);
			},
			getAttribute : (function () {
				var q = function (r) {
					return this.$.getAttribute(r, 2);
				};
				if (h && (g.ie7Compat || g.ie6Compat))
					return function (r) {
						var v = this;
						switch (r) {
						case 'class':
							r = 'className';
							break;
						case 'http-equiv':
							r = 'httpEquiv';
							break;
						case 'name':
							return v.$.name;
						case 'tabindex':
							var s = q.call(v, r);
							if (s !== 0 && v.$.tabIndex === 0)
								s = null;
							return s;
							break;
						case 'checked':
							var t = v.$.attributes.getNamedItem(r),
							u = t.specified ? t.nodeValue : v.$.checked;
							return u ? 'checked' : null;
						case 'hspace':
						case 'value':
							return v.$[r];
						case 'style':
							return v.$.style.cssText;
						case 'contenteditable':
						case 'contentEditable':
							return v.$.attributes.getNamedItem('contentEditable').specified ? v.$.getAttribute('contentEditable') : null;
						}
						return q.call(v, r);
					};
				else
					return q;
			})(),
			getChildren : function () {
				return new i.nodeList(this.$.childNodes);
			},
			getComputedStyle : h ? function (q) {
				return this.$.currentStyle[j.cssStyleToDomStyle(q)];
			}
			 : function (q) {
				var r = this.getWindow().$.getComputedStyle(this.$, null);
				return r ? r.getPropertyValue(q) : '';
			},
			getDtd : function () {
				var q = k[this.getName()];
				this.getDtd = function () {
					return q;
				};
				return q;
			},
			getElementsByTag : l.prototype.getElementsByTag,
			getTabIndex : h ? function () {
				var q = this.$.tabIndex;
				if (q === 0 && !k.$tabIndex[this.getName()] && parseInt(this.getAttribute('tabindex'), 10) !== 0)
					q = -1;
				return q;
			}
			 : g.webkit ? function () {
				var q = this.$.tabIndex;
				if (q == undefined) {
					q = parseInt(this.getAttribute('tabindex'), 10);
					if (isNaN(q))
						q = -1;
				}
				return q;
			}
			 : function () {
				return this.$.tabIndex;
			},
			getText : function () {
				return this.$.textContent || this.$.innerText || '';
			},
			getWindow : function () {
				return this.getDocument().getWindow();
			},
			getId : function () {
				return this.$.id || null;
			},
			getNameAtt : function () {
				return this.$.name || null;
			},
			getName : function () {
				var q = this.$.nodeName.toLowerCase();
				if (h && !(document.documentMode > 8)) {
					var r = this.$.scopeName;
					if (r != 'HTML')
						q = r.toLowerCase() + ':' + q;
				}
				return (this.getName = function () {
					return q;
				})();
			},
			getValue : function () {
				return this.$.value;
			},
			getFirst : function (q) {
				var r = this.$.firstChild,
				s = r && new i.node(r);
				if (s && q && !q(s))
					s = s.getNext(q);
				return s;
			},
			getLast : function (q) {
				var r = this.$.lastChild,
				s = r && new i.node(r);
				if (s && q && !q(s))
					s = s.getPrevious(q);
				return s;
			},
			getStyle : function (q) {
				return this.$.style[j.cssStyleToDomStyle(q)];
			},
			is : function () {
				var q = this.getName();
				for (var r = 0; r < arguments.length; r++) {
					if (arguments[r] == q)
						return true;
				}
				return false;
			},
			isEditable : function (q) {
				var t = this;
				var r = t.getName();
				if (t.isReadOnly() || t.getComputedStyle('display') == 'none' || t.getComputedStyle('visibility') == 'hidden' || t.is('a') && t.data('cke-saved-name') && !t.getChildCount() || k.$nonEditable[r] || k.$empty[r])
					return false;
				if (q !== false) {
					var s = k[r] || k.span;
					return s && s['#'];
				}
				return true;
			},
			isIdentical : function (q) {
				if (this.getName() != q.getName())
					return false;
				var r = this.$.attributes,
				s = q.$.attributes,
				t = r.length,
				u = s.length;
				for (var v = 0; v < t; v++) {
					var w = r[v];
					if (w.nodeName == '_moz_dirty')
						continue;
					if ((!h || w.specified && w.nodeName != 'data-cke-expando') && w.nodeValue != q.getAttribute(w.nodeName))
						return false;
				}
				if (h)
					for (v = 0; v < u; v++) {
						w = s[v];
						if (w.specified && w.nodeName != 'data-cke-expando' && w.nodeValue != this.getAttribute(w.nodeName))
							return false;
					}
				return true;
			},
			isVisible : function () {
				var t = this;
				var q = (t.$.offsetHeight || t.$.offsetWidth) && t.getComputedStyle('visibility') != 'hidden',
				r,
				s;
				if (q && (g.webkit || g.opera)) {
					r = t.getWindow();
					if (!r.equals(f.document.getWindow()) && (s = r.$.frameElement))
						q = new m(s).isVisible();
				}
				return !!q;
			},
			isEmptyInlineRemoveable : function () {
				if (!k.$removeEmpty[this.getName()])
					return false;
				var q = this.getChildren();
				for (var r = 0, s = q.count(); r < s; r++) {
					var t = q.getItem(r);
					if (t.type == 1 && t.data('cke-bookmark'))
						continue;
					if (t.type == 1 && !t.isEmptyInlineRemoveable() || t.type == 3 && j.trim(t.getText()))
						return false;
				}
				return true;
			},
			hasAttributes : h && (g.ie7Compat || g.ie6Compat) ? function () {
				var q = this.$.attributes;
				for (var r = 0; r < q.length; r++) {
					var s = q[r];
					switch (s.nodeName) {
					case 'class':
						if (this.getAttribute('class'))
							return true;
					case 'data-cke-expando':
						continue;
					default:
						if (s.specified)
							return true;
					}
				}
				return false;
			}
			 : function () {
				var q = this.$.attributes,
				r = q.length,
				s = {
					'data-cke-expando' : 1,
					_moz_dirty : 1
				};
				return r > 0 && (r > 2 || !s[q[0].nodeName] || r == 2 && !s[q[1].nodeName]);
			},
			hasAttribute : (function () {
				function q(r) {
					var s = this.$.attributes.getNamedItem(r);
					return !!(s && s.specified);
				};
				return h && g.version < 8 ? function (r) {
					if (r == 'name')
						return !!this.$.name;
					return q.call(this, r);
				}
				 : q;
			})(),
			hide : function () {
				this.setStyle('display', 'none');
			},
			moveChildren : function (q, r) {
				var s = this.$;
				q = q.$;
				if (s == q)
					return;
				var t;
				if (r)
					while (t = s.lastChild)
						q.insertBefore(s.removeChild(t), q.firstChild);
				else
					while (t = s.firstChild)
						q.appendChild(s.removeChild(t));
			},
			mergeSiblings : (function () {
				function q(r, s, t) {
					if (s && s.type == 1) {
						var u = [];
						while (s.data('cke-bookmark') || s.isEmptyInlineRemoveable()) {
							u.push(s);
							s = t ? s.getNext() : s.getPrevious();
							if (!s || s.type != 1)
								return;
						}
						if (r.isIdentical(s)) {
							var v = t ? r.getLast() : r.getFirst();
							while (u.length)
								u.shift().move(r, !t);
							s.moveChildren(r, !t);
							s.remove();
							if (v && v.type == 1)
								v.mergeSiblings();
						}
					}
				};
				return function (r) {
					var s = this;
					if (!(r === false || k.$removeEmpty[s.getName()] || s.is('a')))
						return;
					q(s, s.getNext(), true);
					q(s, s.getPrevious());
				};
			})(),
			show : function () {
				this.setStyles({
					display : '',
					visibility : ''
				});
			},
			setAttribute : (function () {
				var q = function (r, s) {
					this.$.setAttribute(r, s);
					return this;
				};
				if (h && (g.ie7Compat || g.ie6Compat))
					return function (r, s) {
						var t = this;
						if (r == 'class')
							t.$.className = s;
						else if (r == 'style')
							t.$.style.cssText = s;
						else if (r == 'tabindex')
							t.$.tabIndex = s;
						else if (r == 'checked')
							t.$.checked = s;
						else if (r == 'contenteditable')
							q.call(t, 'contentEditable', s);
						else
							q.apply(t, arguments);
						return t;
					};
				else if (g.ie8Compat && g.secure)
					return function (r, s) {
						if (r == 'src' && s.match(/^http:\/\//))
							try {
								q.apply(this, arguments);
							} catch (t) {}
							
						else
							q.apply(this, arguments);
						return this;
					};
				else
					return q;
			})(),
			setAttributes : function (q) {
				for (var r in q)
					this.setAttribute(r, q[r]);
				return this;
			},
			setValue : function (q) {
				this.$.value = q;
				return this;
			},
			removeAttribute : (function () {
				var q = function (r) {
					this.$.removeAttribute(r);
				};
				if (h && (g.ie7Compat || g.ie6Compat))
					return function (r) {
						if (r == 'class')
							r = 'className';
						else if (r == 'tabindex')
							r = 'tabIndex';
						else if (r == 'contenteditable')
							r = 'contentEditable';
						q.call(this, r);
					};
				else
					return q;
			})(),
			removeAttributes : function (q) {
				if (j.isArray(q))
					for (var r = 0; r < q.length; r++)
						this.removeAttribute(q[r]);
				else
					for (var s in q)
						q.hasOwnProperty(s) && this.removeAttribute(s);
			},
			removeStyle : function (q) {
				var u = this;
				var r = u.$.style;
				if (!r.removeProperty && (q == 'border' || q == 'margin' || q == 'padding')) {
					var s = o(q);
					for (var t = 0; t < s.length; t++)
						u.removeStyle(s[t]);
					return;
				}
				r.removeProperty ? r.removeProperty(q) : r.removeAttribute(j.cssStyleToDomStyle(q));
				if (!u.$.style.cssText)
					u.removeAttribute('style');
			},
			setStyle : function (q, r) {
				this.$.style[j.cssStyleToDomStyle(q)] = r;
				return this;
			},
			setStyles : function (q) {
				for (var r in q)
					this.setStyle(r, q[r]);
				return this;
			},
			setOpacity : function (q) {
				if (h && g.version < 9) {
					q = Math.round(q * 100);
					this.setStyle('filter', q >= 100 ? '' : 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + q + ')');
				} else
					this.setStyle('opacity', q);
			},
			unselectable : g.gecko ? function () {
				this.$.style.MozUserSelect = 'none';
				this.on('dragstart', function (q) {
					q.data.preventDefault();
				});
			}
			 : g.webkit ? function () {
				this.$.style.KhtmlUserSelect = 'none';
				this.on('dragstart', function (q) {
					q.data.preventDefault();
				});
			}
			 : function () {
				if (h || g.opera) {
					var q = this.$,
					r = q.getElementsByTagName('*'),
					s,
					t = 0;
					q.unselectable = 'on';
					while (s = r[t++])
						switch (s.tagName.toLowerCase()) {
						case 'iframe':
						case 'textarea':
						case 'input':
						case 'select':
							break;
						default:
							s.unselectable = 'on';
						}
				}
			},
			getPositionedAncestor : function () {
				var q = this;
				while (q.getName() != 'html') {
					if (q.getComputedStyle('position') != 'static')
						return q;
					q = q.getParent();
				}
				return null;
			},
			getDocumentPosition : function (q) {
				var L = this;
				var r = 0,
				s = 0,
				t = L.getDocument(),
				u = t.getBody(),
				v = t.$.compatMode == 'BackCompat';
				if (document.documentElement.getBoundingClientRect) {
					var w = L.$.getBoundingClientRect(),
					x = t.$,
					y = x.documentElement,
					z = y.clientTop || u.$.clientTop || 0,
					A = y.clientLeft || u.$.clientLeft || 0,
					B = true;
					if (h) {
						var C = t.getDocumentElement().contains(L),
						D = t.getBody().contains(L);
						B = v && D || !v && C;
					}
					if (B) {
						r = w.left + (!v && y.scrollLeft || u.$.scrollLeft);
						r -= A;
						s = w.top + (!v && y.scrollTop || u.$.scrollTop);
						s -= z;
					}
				} else {
					var E = L,
					F = null,
					G;
					while (E && !(E.getName() == 'body' || E.getName() == 'html')) {
						r += E.$.offsetLeft - E.$.scrollLeft;
						s += E.$.offsetTop - E.$.scrollTop;
						if (!E.equals(L)) {
							r += E.$.clientLeft || 0;
							s += E.$.clientTop || 0;
						}
						var H = F;
						while (H && !H.equals(E)) {
							r -= H.$.scrollLeft;
							s -= H.$.scrollTop;
							H = H.getParent();
						}
						F = E;
						E = (G = E.$.offsetParent) ? new m(G) : null;
					}
				}
				if (q) {
					var I = L.getWindow(),
					J = q.getWindow();
					if (!I.equals(J) && I.$.frameElement) {
						var K = new m(I.$.frameElement).getDocumentPosition(q);
						r += K.x;
						s += K.y;
					}
				}
				if (!document.documentElement.getBoundingClientRect)
					if (g.gecko && !v) {
						r += L.$.clientLeft ? 1 : 0;
						s += L.$.clientTop ? 1 : 0;
					}
				return {
					x : r,
					y : s
				};
			},
			scrollIntoView : function (q) {
				var r = this.getParent();
				if (!r)
					return;
				do {
					var s = r.$.clientWidth && r.$.clientWidth < r.$.scrollWidth || r.$.clientHeight && r.$.clientHeight < r.$.scrollHeight;
					if (s)
						this.scrollIntoParent(r, q, 1);
					if (r.is('html')) {
						var t = r.getWindow();
						try {
							var u = t.$.frameElement;
							u && (r = new m(u));
						} catch (v) {}
						
					}
				} while (r = r.getParent())
			},
			scrollIntoParent : function (q, r, s) {
				!q && (q = this.getWindow());
				var t = q.getDocument(),
				u = t.$.compatMode == 'BackCompat';
				if (q instanceof i.window)
					q = u ? t.getBody() : t.getDocumentElement();
				function v(H, I) {
					if (/body|html/.test(q.getName()))
						q.getWindow().$.scrollBy(H, I);
					else {
						q.$.scrollLeft += H;
						q.$.scrollTop += I;
					}
				};
				function w(H, I) {
					var J = {
						x : 0,
						y : 0
					};
					if (!H.is(u ? 'body' : 'html')) {
						var K = H.$.getBoundingClientRect();
						J.x = K.left,
						J.y = K.top;
					}
					var L = H.getWindow();
					if (!L.equals(I)) {
						var M = w(m.get(L.$.frameElement), I);
						J.x += M.x,
						J.y += M.y;
					}
					return J;
				};
				function x(H, I) {
					return parseInt(H.getComputedStyle('margin-' + I) || 0, 10) || 0;
				};
				var y = q.getWindow(),
				z = w(this, y),
				A = w(q, y),
				B = this.$.offsetHeight,
				C = this.$.offsetWidth,
				D = q.$.clientHeight,
				E = q.$.clientWidth,
				F,
				G;
				F = {
					x : z.x - x(this, 'left') - A.x || 0,
					y : z.y - x(this, 'top') - A.y || 0
				};
				G = {
					x : z.x + C + x(this, 'right') - (A.x + E) || 0,
					y : z.y + B + x(this, 'bottom') - (A.y + D) || 0
				};
				if (F.y < 0 || G.y > 0)
					v(0, r === true ? F.y : r === false ? G.y : F.y < 0 ? F.y : G.y);
				if (s && (F.x < 0 || G.x > 0))
					v(F.x < 0 ? F.x : G.x, 0);
			},
			setState : function (q) {
				var r = this;
				switch (q) {
				case 1:
					r.addClass('cke_on');
					r.removeClass('cke_off');
					r.removeClass('cke_disabled');
					break;
				case 0:
					r.addClass('cke_disabled');
					r.removeClass('cke_off');
					r.removeClass('cke_on');
					break;
				default:
					r.addClass('cke_off');
					r.removeClass('cke_on');
					r.removeClass('cke_disabled');
					break;
				}
			},
			getFrameDocument : function () {
				var q = this.$;
				try {
					q.contentWindow.document;
				} catch (r) {
					q.src = q.src;
					if (h && g.version < 7)
						window.showModalDialog('javascript:document.write("<script>window.setTimeout(function(){window.close();},50);</script>")');
				}
				return q && new l(q.contentWindow.document);
			},
			copyAttributes : function (q, r) {
				var x = this;
				var s = x.$.attributes;
				r = r || {};
				for (var t = 0; t < s.length; t++) {
					var u = s[t],
					v = u.nodeName.toLowerCase(),
					w;
					if (v in r)
						continue;
					if (v == 'checked' && (w = x.getAttribute(v)))
						q.setAttribute(v, w);
					else if (u.specified || h && u.nodeValue && v == 'value') {
						w = x.getAttribute(v);
						if (w === null)
							w = u.nodeValue;
						q.setAttribute(v, w);
					}
				}
				if (x.$.style.cssText !== '')
					q.$.style.cssText = x.$.style.cssText;
			},
			renameNode : function (q) {
				var t = this;
				if (t.getName() == q)
					return;
				var r = t.getDocument(),
				s = new m(q, r);
				t.copyAttributes(s);
				t.moveChildren(s);
				t.getParent() && t.$.parentNode.replaceChild(s.$, t.$);
				s.$['data-cke-expando'] = t.$['data-cke-expando'];
				t.$ = s.$;
			},
			getChild : function (q) {
				var r = this.$;
				if (!q.slice)
					r = r.childNodes[q];
				else
					while (q.length > 0 && r)
						r = r.childNodes[q.shift()];
				return r ? new i.node(r) : null;
			},
			getChildCount : function () {
				return this.$.childNodes.length;
			},
			disableContextMenu : function () {
				this.on('contextmenu', function (q) {
					if (!q.data.getTarget().hasClass('cke_enable_context_menu'))
						q.data.preventDefault();
				});
			},
			getDirection : function (q) {
				var r = this;
				return q ? r.getComputedStyle('direction') || r.getDirection() || r.getDocument().$.dir || r.getDocument().getBody().getDirection(1) : r.getStyle('direction') || r.getAttribute('dir');
			},
			data : function (q, r) {
				q = 'data-' + q;
				if (r === undefined)
					return this.getAttribute(q);
				else if (r === false)
					this.removeAttribute(q);
				else
					this.setAttribute(q, r);
				return null;
			}
		});
		var n = {
			width : ['border-left-width', 'border-right-width', 'padding-left', 'padding-right'],
			height : ['border-top-width', 'border-bottom-width', 'padding-top', 'padding-bottom']
		};
		function o(q) {
			var r = ['top', 'left', 'right', 'bottom'],
			s;
			if (q == 'border')
				s = ['color', 'style', 'width'];
			var t = [];
			for (var u = 0; u < r.length; u++) {
				if (s)
					for (var v = 0; v < s.length; v++)
						t.push([q, r[u], s[v]].join('-'));
				else
					t.push([q, r[u]].join('-'));
			}
			return t;
		};
		function p(q) {
			var r = 0;
			for (var s = 0, t = n[q].length; s < t; s++)
				r += parseInt(this.getComputedStyle(n[q][s]) || 0, 10) || 0;
			return r;
		};
		m.prototype.setSize = function (q, r, s) {
			if (typeof r == 'number') {
				if (s && !(h && g.quirks))
					r -= p.call(this, q);
				this.setStyle(q, r + 'px');
			}
		};
		m.prototype.getSize = function (q, r) {
			var s = Math.max(this.$['offset' + j.capitalize(q)], this.$['client' + j.capitalize(q)]) || 0;
			if (r)
				s -= p.call(this, q);
			return s;
		};
	})();
	f.command = function (n, o) {
		this.uiItems = [];
		this.exec = function (p) {
			var q = this;
			if (q.state == 0)
				return false;
			if (q.editorFocus)
				n.focus();
			if (q.fire('exec') === true)
				return true;
			return o.exec.call(q, n, p) !== false;
		};
		this.refresh = function () {
			if (this.fire('refresh') === true)
				return true;
			return o.refresh && o.refresh.apply(this, arguments) !== false;
		};
		j.extend(this, o, {
			modes : {
				wysiwyg : 1
			},
			editorFocus : 1,
			state : 2
		});
		f.event.call(this);
	};
	f.command.prototype = {
		enable : function () {
			var n = this;
			if (n.state == 0)
				n.setState(!n.preserveState || typeof n.previousState == 'undefined' ? 2 : n.previousState);
		},
		disable : function () {
			this.setState(0);
		},
		setState : function (n) {
			var o = this;
			if (o.state == n)
				return false;
			o.previousState = o.state;
			o.state = n;
			o.fire('state');
			return true;
		},
		toggleState : function () {
			var n = this;
			if (n.state == 2)
				n.setState(1);
			else if (n.state == 1)
				n.setState(2);
		}
	};
	f.event.implementOn(f.command.prototype, true);
	f.ENTER_P = 1;
	f.ENTER_BR = 2;
	f.ENTER_DIV = 3;
	f.config = {
		customConfig : 'config.js',
		autoUpdateElement : true,
		baseHref : '',
		contentsCss : f.basePath + 'contents.css',
		contentsLangDirection : 'ui',
		contentsLanguage : '',
		language : '',
		defaultLanguage : 'en',
		enterMode : 1,
		forceEnterMode : false,
		shiftEnterMode : 2,
		corePlugins : '',
		docType : '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
		bodyId : '',
		bodyClass : '',
		fullPage : false,
		height : 200,
		plugins : 'about,a11yhelp,basicstyles,bidi,blockquote,button,clipboard,colorbutton,colordialog,contextmenu,dialogadvtab,div,elementspath,enterkey,entities,filebrowser,find,flash,font,format,forms,horizontalrule,htmldataprocessor,iframe,image,indent,justify,keystrokes,link,list,liststyle,maximize,newpage,pagebreak,pastefromword,pastetext,popup,preview,print,removeformat,resize,save,scayt,showblocks,showborders,smiley,sourcearea,specialchar,stylescombo,tab,table,tabletools,templates,toolbar,undo,wsc,wysiwygarea',
		extraPlugins : '',
		removePlugins : '',
		protectedSource : [],
		tabIndex : 0,
		theme : 'default',
		skin : 'kama',
		width : '',
		baseFloatZIndex : 10000
	};
	var n = f.config;
	f.focusManager = function (o) {
		if (o.focusManager)
			return o.focusManager;
		this.hasFocus = false;
		this._ = {
			editor : o
		};
		return this;
	};
	f.focusManager.prototype = {
		focus : function () {
			var p = this;
			if (p._.timer)
				clearTimeout(p._.timer);
			if (!p.hasFocus) {
				if (f.currentInstance)
					f.currentInstance.focusManager.forceBlur();
				var o = p._.editor;
				o.container.getChild(1).addClass('cke_focus');
				p.hasFocus = true;
				o.fire('focus');
			}
		},
		blur : function () {
			var o = this;
			if (o._.timer)
				clearTimeout(o._.timer);
			o._.timer = setTimeout(function () {
					delete o._.timer;
					o.forceBlur();
				}, 100);
		},
		forceBlur : function () {
			if (this.hasFocus) {
				var o = this._.editor;
				o.container.getChild(1).removeClass('cke_focus');
				this.hasFocus = false;
				o.fire('blur');
			}
		}
	};
	(function () {
		var o = {};
		f.lang = {
			languages : {
				af : 1,
				ar : 1,
				bg : 1,
				bn : 1,
				bs : 1,
				ca : 1,
				cs : 1,
				cy : 1,
				da : 1,
				de : 1,
				el : 1,
				'en-au' : 1,
				'en-ca' : 1,
				'en-gb' : 1,
				en : 1,
				eo : 1,
				es : 1,
				et : 1,
				eu : 1,
				fa : 1,
				fi : 1,
				fo : 1,
				'fr-ca' : 1,
				fr : 1,
				gl : 1,
				gu : 1,
				he : 1,
				hi : 1,
				hr : 1,
				hu : 1,
				is : 1,
				it : 1,
				ja : 1,
				ka : 1,
				km : 1,
				ko : 1,
				ku : 1,
				lt : 1,
				lv : 1,
				mn : 1,
				ms : 1,
				nb : 1,
				nl : 1,
				no : 1,
				pl : 1,
				'pt-br' : 1,
				pt : 1,
				ro : 1,
				ru : 1,
				sk : 1,
				sl : 1,
				'sr-latn' : 1,
				sr : 1,
				sv : 1,
				th : 1,
				tr : 1,
				ug : 1,
				uk : 1,
				vi : 1,
				'zh-cn' : 1,
				zh : 1
			},
			load : function (p, q, r) {
				if (!p || !f.lang.languages[p])
					p = this.detect(q, p);
				if (!this[p])
					f.scriptLoader.load(f.getUrl('lang/' + p + '.js'), function () {
						r(p, this[p]);
					}, this);
				else
					r(p, this[p]);
			},
			detect : function (p, q) {
				var r = this.languages;
				q = q || navigator.userLanguage || navigator.language || p;
				var s = q.toLowerCase().match(/([a-z]+)(?:-([a-z]+))?/),
				t = s[1],
				u = s[2];
				if (r[t + '-' + u])
					t = t + '-' + u;
				else if (!r[t])
					t = null;
				f.lang.detect = t ? function () {
					return t;
				}
				 : function (v) {
					return v;
				};
				return t || p;
			}
		};
	})();
	f.scriptLoader = (function () {
		var o = {},
		p = {};
		return {
			load : function (q, r, s, t) {
				var u = typeof q == 'string';
				if (u)
					q = [q];
				if (!s)
					s = f;
				var v = q.length,
				w = [],
				x = [],
				y = function (D) {
					if (r)
						if (u)
							r.call(s, D);
						else
							r.call(s, w, x);
				};
				if (v === 0) {
					y(true);
					return;
				}
				var z = function (D, E) {
					(E ? w : x).push(D);
					if (--v <= 0) {
						t && f.document.getDocumentElement().removeStyle('cursor');
						y(E);
					}
				},
				A = function (D, E) {
					o[D] = 1;
					var F = p[D];
					delete p[D];
					for (var G = 0; G < F.length; G++)
						F[G](D, E);
				},
				B = function (D) {
					if (o[D]) {
						z(D, true);
						return;
					}
					var E = p[D] || (p[D] = []);
					E.push(z);
					if (E.length > 1)
						return;
					var F = new m('script');
					F.setAttributes({
						type : 'text/javascript',
						src : D
					});
					if (r)
						if (h)
							F.$.onreadystatechange = function () {
								if (F.$.readyState == 'loaded' || F.$.readyState == 'complete') {
									F.$.onreadystatechange = null;
									A(D, true);
								}
							};
						else {
							F.$.onload = function () {
								setTimeout(function () {
									A(D, true);
								}, 0);
							};
							F.$.onerror = function () {
								A(D, false);
							};
						}
					F.appendTo(f.document.getHead());
				};
				t && f.document.getDocumentElement().setStyle('cursor', 'wait');
				for (var C = 0; C < v; C++)
					B(q[C]);
			}
		};
	})();
	f.resourceManager = function (o, p) {
		var q = this;
		q.basePath = o;
		q.fileName = p;
		q.registered = {};
		q.loaded = {};
		q.externals = {};
		q._ = {
			waitingList : {}
			
		};
	};
	f.resourceManager.prototype = {
		add : function (o, p) {
			if (this.registered[o])
				throw '[CKEDITOR.resourceManager.add] The resource name "' + o + '" is already registered.';
			f.fire(o + j.capitalize(this.fileName) + 'Ready', this.registered[o] = p || {});
		},
		get : function (o) {
			return this.registered[o] || null;
		},
		getPath : function (o) {
			var p = this.externals[o];
			return f.getUrl(p && p.dir || this.basePath + o + '/');
		},
		getFilePath : function (o) {
			var p = this.externals[o];
			return f.getUrl(this.getPath(o) + (p && typeof p.file == 'string' ? p.file : this.fileName + '.js'));
		},
		addExternal : function (o, p, q) {
			o = o.split(',');
			for (var r = 0; r < o.length; r++) {
				var s = o[r];
				this.externals[s] = {
					dir : p,
					file : q
				};
			}
		},
		load : function (o, p, q) {
			if (!j.isArray(o))
				o = o ? [o] : [];
			var r = this.loaded,
			s = this.registered,
			t = [],
			u = {},
			v = {};
			for (var w = 0; w < o.length; w++) {
				var x = o[w];
				if (!x)
					continue;
				if (!r[x] && !s[x]) {
					var y = this.getFilePath(x);
					t.push(y);
					if (!(y in u))
						u[y] = [];
					u[y].push(x);
				} else
					v[x] = this.get(x);
			}
			f.scriptLoader.load(t, function (z, A) {
				if (A.length)
					throw '[CKEDITOR.resourceManager.load] Resource name "' + u[A[0]].join(',') + '" was not found at "' + A[0] + '".';
				for (var B = 0; B < z.length; B++) {
					var C = u[z[B]];
					for (var D = 0; D < C.length; D++) {
						var E = C[D];
						v[E] = this.get(E);
						r[E] = 1;
					}
				}
				p.call(q, v);
			}, this);
		}
	};
	f.plugins = new f.resourceManager('plugins/', 'plugin');
	var o = f.plugins;
	o.load = j.override(o.load, function (p) {
			return function (q, r, s) {
				var t = {},
				u = function (v) {
					p.call(this, v, function (w) {
						j.extend(t, w);
						var x = [];
						for (var y in w) {
							var z = w[y],
							A = z && z.requires;
							if (A)
								for (var B = 0; B < A.length; B++) {
									if (!t[A[B]])
										x.push(A[B]);
								}
						}
						if (x.length)
							u.call(this, x);
						else {
							for (y in t) {
								z = t[y];
								if (z.onLoad && !z.onLoad._called) {
									z.onLoad();
									z.onLoad._called = 1;
								}
							}
							if (r)
								r.call(s || window, t);
						}
					}, this);
				};
				u.call(this, q);
			};
		});
	o.setLang = function (p, q, r) {
		var s = this.get(p),
		t = s.langEntries || (s.langEntries = {}),
		u = s.lang || (s.lang = []);
		if (j.indexOf(u, q) == -1)
			u.push(q);
		t[q] = r;
	};
	f.skins = (function () {
		var p = {},
		q = {},
		r = function (s, t, u, v) {
			var w = p[t];
			if (!s.skin) {
				s.skin = w;
				if (w.init)
					w.init(s);
			}
			var x = function (G) {
				for (var H = 0; H < G.length; H++)
					G[H] = f.getUrl(q[t] + G[H]);
			};
			function y(G, H) {
				return G.replace(/url\s*\(([\s'"]*)(.*?)([\s"']*)\)/g, function (I, J, K, L) {
					if (/^\/|^\w?:/.test(K))
						return I;
					else
						return 'url(' + H + J + K + L + ')';
				});
			};
			u = w[u];
			var z = !u || !!u._isLoaded;
			if (z)
				v && v();
			else {
				var A = u._pending || (u._pending = []);
				A.push(v);
				if (A.length > 1)
					return;
				var B = !u.css || !u.css.length,
				C = !u.js || !u.js.length,
				D = function () {
					if (B && C) {
						u._isLoaded = 1;
						for (var G = 0; G < A.length; G++) {
							if (A[G])
								A[G]();
						}
					}
				};
				if (!B) {
					var E = u.css;
					if (j.isArray(E)) {
						x(E);
						for (var F = 0; F < E.length; F++)
							f.document.appendStyleSheet(E[F]);
					} else {
						E = y(E, f.getUrl(q[t]));
						f.document.appendStyleText(E);
					}
					u.css = E;
					B = 1;
				}
				if (!C) {
					x(u.js);
					f.scriptLoader.load(u.js, function () {
						C = 1;
						D();
					});
				}
				D();
			}
		};
		return {
			add : function (s, t) {
				p[s] = t;
				t.skinPath = q[s] || (q[s] = f.getUrl('skins/' + s + '/'));
			},
			load : function (s, t, u) {
				var v = s.skinName,
				w = s.skinPath;
				if (p[v])
					r(s, v, t, u);
				else {
					q[v] = w;
					f.scriptLoader.load(f.getUrl(w + 'skin.js'), function () {
						r(s, v, t, u);
					});
				}
			}
		};
	})();
	f.themes = new f.resourceManager('themes/', 'theme');
	f.ui = function (p) {
		if (p.ui)
			return p.ui;
		this._ = {
			handlers : {},
			items : {},
			editor : p
		};
		return this;
	};
	var p = f.ui;
	p.prototype = {
		add : function (q, r, s) {
			this._.items[q] = {
				type : r,
				command : s.command || null,
				args : Array.prototype.slice.call(arguments, 2)
			};
		},
		create : function (q) {
			var v = this;
			var r = v._.items[q],
			s = r && v._.handlers[r.type],
			t = r && r.command && v._.editor.getCommand(r.command),
			u = s && s.create.apply(v, r.args);
			r && (u = j.extend(u, v._.editor.skin[r.type], true));
			if (t)
				t.uiItems.push(u);
			return u;
		},
		addHandler : function (q, r) {
			this._.handlers[q] = r;
		}
	};
	f.event.implementOn(p);
	(function () {
		var q = 0,
		r = function () {
			var C = 'editor' + ++q;
			return f.instances && f.instances[C] ? r() : C;
		},
		s = {},
		t = function (C) {
			var D = C.config.customConfig;
			if (!D)
				return false;
			D = f.getUrl(D);
			var E = s[D] || (s[D] = {});
			if (E.fn) {
				E.fn.call(C, C.config);
				if (f.getUrl(C.config.customConfig) == D || !t(C))
					C.fireOnce('customConfigLoaded');
			} else
				f.scriptLoader.load(D, function () {
					if (f.editorConfig)
						E.fn = f.editorConfig;
					else
						E.fn = function () {};
					t(C);
				});
			return true;
		},
		u = function (C, D) {
			C.on('customConfigLoaded', function () {
				if (D) {
					if (D.on)
						for (var E in D.on)
							C.on(E, D.on[E]);
					j.extend(C.config, D, true);
					delete C.config.on;
				}
				v(C);
			});
			if (D && D.customConfig != undefined)
				C.config.customConfig = D.customConfig;
			if (!t(C))
				C.fireOnce('customConfigLoaded');
		},
		v = function (C) {
			var D = C.config.skin.split(','),
			E = D[0],
			F = f.getUrl(D[1] || 'skins/' + E + '/');
			C.skinName = E;
			C.skinPath = F;
			C.skinClass = 'cke_skin_' + E;
			C.tabIndex = C.config.tabIndex || C.element.getAttribute('tabindex') || 0;
			C.readOnly = !!(C.config.readOnly || C.element.getAttribute('disabled'));
			C.fireOnce('configLoaded');
			y(C);
		},
		w = function (C) {
			f.lang.load(C.config.language, C.config.defaultLanguage, function (D, E) {
				C.langCode = D;
				C.lang = j.prototypedCopy(E);
				if (g.gecko && g.version < 10900 && C.lang.dir == 'rtl')
					C.lang.dir = 'ltr';
				C.fire('langLoaded');
				var F = C.config;
				F.contentsLangDirection == 'ui' && (F.contentsLangDirection = C.lang.dir);
				x(C);
			});
		},
		x = function (C) {
			var D = C.config,
			E = D.plugins,
			F = D.extraPlugins,
			G = D.removePlugins;
			if (F) {
				var H = new RegExp('(?:^|,)(?:' + F.replace(/\s*,\s*/g, '|') + ')(?=,|$)', 'g');
				E = E.replace(H, '');
				E += ',' + F;
			}
			if (G) {
				H = new RegExp('(?:^|,)(?:' + G.replace(/\s*,\s*/g, '|') + ')(?=,|$)', 'g');
				E = E.replace(H, '');
			}
			g.air && (E += ',adobeair');
			o.load(E.split(','), function (I) {
				var J = [],
				K = [],
				L = [];
				C.plugins = I;
				for (var M in I) {
					var N = I[M],
					O = N.lang,
					P = o.getPath(M),
					Q = null;
					N.path = P;
					if (O) {
						Q = j.indexOf(O, C.langCode) >= 0 ? C.langCode : O[0];
						if (!N.langEntries || !N.langEntries[Q])
							L.push(f.getUrl(P + 'lang/' + Q + '.js'));
						else {
							j.extend(C.lang, N.langEntries[Q]);
							Q = null;
						}
					}
					K.push(Q);
					J.push(N);
				}
				f.scriptLoader.load(L, function () {
					var R = ['beforeInit', 'init', 'afterInit'];
					for (var S = 0; S < R.length; S++)
						for (var T = 0; T < J.length; T++) {
							var U = J[T];
							if (S === 0 && K[T] && U.lang)
								j.extend(C.lang, U.langEntries[K[T]]);
							if (U[R[S]])
								U[R[S]](C);
						}
					C.fire('pluginsLoaded');
					z(C);
				});
			});
		},
		y = function (C) {
			f.skins.load(C, 'editor', function () {
				w(C);
			});
		},
		z = function (C) {
			var D = C.config.theme;
			f.themes.load(D, function () {
				var E = C.theme = f.themes.get(D);
				E.path = f.themes.getPath(D);
				E.build(C);
				if (C.config.autoUpdateElement)
					A(C);
			});
		},
		A = function (C) {
			var D = C.element;
			if (C.elementMode == 1 && D.is('textarea')) {
				var E = D.$.form && new m(D.$.form);
				if (E) {
					function F() {
						C.updateElement();
					};
					E.on('submit', F);
					if (!E.$.submit.nodeName && !E.$.submit.length)
						E.$.submit = j.override(E.$.submit, function (G) {
								return function () {
									C.updateElement();
									if (G.apply)
										G.apply(this, arguments);
									else
										G();
								};
							});
					C.on('destroy', function () {
						E.removeListener('submit', F);
					});
				}
			}
		};
		function B() {
			var C,
			D = this._.commands,
			E = this.mode;
			if (!E)
				return;
			for (var F in D) {
				C = D[F];
				C[C.startDisabled ? 'disable' : this.readOnly && !C.readOnly ? 'disable' : C.modes[E] ? 'enable' : 'disable']();
			}
		};
		f.editor.prototype._init = function () {
			var E = this;
			var C = m.get(E._.element),
			D = E._.instanceConfig;
			delete E._.element;
			delete E._.instanceConfig;
			E._.commands = {};
			E._.styles = [];
			E.element = C;
			E.name = C && E.elementMode == 1 && (C.getId() || C.getNameAtt()) || r();
			if (E.name in f.instances)
				throw '[CKEDITOR.editor] The instance "' + E.name + '" already exists.';
			E.id = j.getNextId();
			E.config = j.prototypedCopy(n);
			E.ui = new p(E);
			E.focusManager = new f.focusManager(E);
			f.fire('instanceCreated', null, E);
			E.on('mode', B, null, null, 1);
			E.on('readOnly', B, null, null, 1);
			u(E, D);
		};
	})();
	j.extend(f.editor.prototype, {
		addCommand : function (q, r) {
			return this._.commands[q] = new f.command(this, r);
		},
		addCss : function (q) {
			this._.styles.push(q);
		},
		destroy : function (q) {
			var r = this;
			if (!q)
				r.updateElement();
			r.fire('destroy');
			r.theme && r.theme.destroy(r);
			f.remove(r);
			f.fire('instanceDestroyed', null, r);
		},
		execCommand : function (q, r) {
			var s = this.getCommand(q),
			t = {
				name : q,
				commandData : r,
				command : s
			};
			if (s && s.state != 0)
				if (this.fire('beforeCommandExec', t) !== true) {
					t.returnValue = s.exec(t.commandData);
					if (!s.async && this.fire('afterCommandExec', t) !== true)
						return t.returnValue;
				}
			return false;
		},
		getCommand : function (q) {
			return this._.commands[q];
		},
		getData : function () {
			var s = this;
			s.fire('beforeGetData');
			var q = s._.data;
			if (typeof q != 'string') {
				var r = s.element;
				if (r && s.elementMode == 1)
					q = r.is('textarea') ? r.getValue() : r.getHtml();
				else
					q = '';
			}
			q = {
				dataValue : q
			};
			s.fire('getData', q);
			return q.dataValue;
		},
		getSnapshot : function () {
			var q = this.fire('getSnapshot');
			if (typeof q != 'string') {
				var r = this.element;
				if (r && this.elementMode == 1)
					q = r.is('textarea') ? r.getValue() : r.getHtml();
			}
			return q;
		},
		loadSnapshot : function (q) {
			this.fire('loadSnapshot', q);
		},
		setData : function (q, r, s) {
			if (r)
				this.on('dataReady', function (u) {
					u.removeListener();
					r.call(u.editor);
				});
			var t = {
				dataValue : q
			};
			!s && this.fire('setData', t);
			this._.data = t.dataValue;
			!s && this.fire('afterSetData', t);
		},
		setReadOnly : function (q) {
			q = q == undefined || q;
			if (this.readOnly != q) {
				this.readOnly = q;
				this.fire('readOnly');
			}
		},
		insertHtml : function (q) {
			this.fire('insertHtml', q);
		},
		insertText : function (q) {
			this.fire('insertText', q);
		},
		insertElement : function (q) {
			this.fire('insertElement', q);
		},
		checkDirty : function () {
			return this.mayBeDirty && this._.previousValue !== this.getSnapshot();
		},
		resetDirty : function () {
			if (this.mayBeDirty)
				this._.previousValue = this.getSnapshot();
		},
		updateElement : function () {
			var s = this;
			var q = s.element;
			if (q && s.elementMode == 1) {
				var r = s.getData();
				if (s.config.htmlEncodeOutput)
					r = j.htmlEncode(r);
				if (q.is('textarea'))
					q.setValue(r);
				else
					q.setHtml(r);
			}
		}
	});
	f.on('loaded', function () {
		var q = f.editor._pending;
		if (q) {
			delete f.editor._pending;
			for (var r = 0; r < q.length; r++)
				q[r]._init();
		}
	});
	f.htmlParser = function () {
		this._ = {
			htmlPartsRegex : new RegExp("<(?:(?:\\/([^>]+)>)|(?:!--([\\S|\\s]*?)-->)|(?:([^\\s>]+)\\s*((?:(?:\"[^\"]*\")|(?:'[^']*')|[^\"'>])*)\\/?>))", 'g')
		};
	};
	(function () {
		var q = /([\w\-:.]+)(?:(?:\s*=\s*(?:(?:"([^"]*)")|(?:'([^']*)')|([^\s>]+)))|(?=\s|$))/g,
		r = {
			checked : 1,
			compact : 1,
			declare : 1,
			defer : 1,
			disabled : 1,
			ismap : 1,
			multiple : 1,
			nohref : 1,
			noresize : 1,
			noshade : 1,
			nowrap : 1,
			readonly : 1,
			selected : 1
		};
		f.htmlParser.prototype = {
			onTagOpen : function () {},
			onTagClose : function () {},
			onText : function () {},
			onCDATA : function () {},
			onComment : function () {},
			parse : function (s) {
				var F = this;
				var t,
				u,
				v = 0,
				w;
				while (t = F._.htmlPartsRegex.exec(s)) {
					var x = t.index;
					if (x > v) {
						var y = s.substring(v, x);
						if (w)
							w.push(y);
						else
							F.onText(y);
					}
					v = F._.htmlPartsRegex.lastIndex;
					if (u = t[1]) {
						u = u.toLowerCase();
						if (w && k.$cdata[u]) {
							F.onCDATA(w.join(''));
							w = null;
						}
						if (!w) {
							F.onTagClose(u);
							continue;
						}
					}
					if (w) {
						w.push(t[0]);
						continue;
					}
					if (u = t[3]) {
						u = u.toLowerCase();
						if (/="/.test(u))
							continue;
						var z = {},
						A,
						B = t[4],
						C = !!(B && B.charAt(B.length - 1) == '/');
						if (B)
							while (A = q.exec(B)) {
								var D = A[1].toLowerCase(),
								E = A[2] || A[3] || A[4] || '';
								if (!E && r[D])
									z[D] = D;
								else
									z[D] = E;
							}
						F.onTagOpen(u, z, C);
						if (!w && k.$cdata[u])
							w = [];
						continue;
					}
					if (u = t[2])
						F.onComment(u);
				}
				if (s.length > v)
					F.onText(s.substring(v, s.length));
			}
		};
	})();
	f.htmlParser.comment = function (q) {
		this.value = q;
		this._ = {
			isBlockLike : false
		};
	};
	f.htmlParser.comment.prototype = {
		type : 8,
		writeHtml : function (q, r) {
			var s = this.value;
			if (r) {
				if (!(s = r.onComment(s, this)))
					return;
				if (typeof s != 'string') {
					s.parent = this.parent;
					s.writeHtml(q, r);
					return;
				}
			}
			q.comment(s);
		}
	};
	(function () {
		f.htmlParser.text = function (q) {
			this.value = q;
			this._ = {
				isBlockLike : false
			};
		};
		f.htmlParser.text.prototype = {
			type : 3,
			writeHtml : function (q, r) {
				var s = this.value;
				if (r && !(s = r.onText(s, this)))
					return;
				q.text(s);
			}
		};
	})();
	(function () {
		f.htmlParser.cdata = function (q) {
			this.value = q;
		};
		f.htmlParser.cdata.prototype = {
			type : 3,
			writeHtml : function (q) {
				q.write(this.value);
			}
		};
	})();
	f.htmlParser.fragment = function () {
		this.children = [];
		this.parent = null;
		this._ = {
			isBlockLike : true,
			hasInlineStarted : false
		};
	};
	(function () {
		var q = j.extend({
				table : 1,
				ul : 1,
				ol : 1,
				dl : 1
			}, k.table, k.ul, k.ol, k.dl),
		r = h && g.version < 8 ? {
			dd : 1,
			dt : 1
		}
		 : {},
		s = {
			ol : 1,
			ul : 1
		},
		t = j.extend({}, {
				html : 1
			}, k.html, k.body, k.head, {
				style : 1,
				script : 1
			});
		function u(v) {
			return v.name == 'a' && v.attributes.href || k.$removeEmpty[v.name];
		};
		f.htmlParser.fragment.fromHtml = function (v, w, x) {
			var y = new f.htmlParser(),
			z = x || new f.htmlParser.fragment(),
			A = [],
			B = [],
			C = z,
			D = false,
			E = false;
			function F(I) {
				var J;
				if (A.length > 0)
					for (var K = 0; K < A.length; K++) {
						var L = A[K],
						M = L.name,
						N = k[M],
						O = C.name && k[C.name];
						if ((!O || O[M]) && (!I || !N || N[I] || !k[I])) {
							if (!J) {
								G();
								J = 1;
							}
							L = L.clone();
							L.parent = C;
							C = L;
							A.splice(K, 1);
							K--;
						} else if (M == C.name)
							H(C, C.parent, 1), K--;
					}
			};
			function G() {
				while (B.length)
					C.add(B.shift());
			};
			function H(I, J, K) {
				if (I.previous !== undefined)
					return;
				J = J || C || z;
				var L = C;
				if (w && (!J.type || J.name == 'body')) {
					var M,
					N;
					if (I.attributes && (N = I.attributes['data-cke-real-element-type']))
						M = N;
					else
						M = I.name;
					if (M && !(M in k.$body || M == 'body' || I.isOrphan)) {
						C = J;
						y.onTagOpen(w, {});
						I.returnPoint = J = C;
					}
				}
				if (I._.isBlockLike && I.name != 'pre' && I.name != 'textarea') {
					var O = I.children.length,
					P = I.children[O - 1],
					Q;
					if (P && P.type == 3)
						if (!(Q = j.rtrim(P.value)))
							I.children.length = O - 1;
						else
							P.value = Q;
				}
				J.add(I);
				if (I.name == 'pre')
					E = false;
				if (I.name == 'textarea')
					D = false;
				if (I.returnPoint) {
					C = I.returnPoint;
					delete I.returnPoint;
				} else
					C = K ? J : L;
			};
			y.onTagOpen = function (I, J, K, L) {
				var M = new f.htmlParser.element(I, J);
				if (M.isUnknown && K)
					M.isEmpty = true;
				M.isOptionalClose = I in r || L;
				if (u(M)) {
					A.push(M);
					return;
				} else if (I == 'pre')
					E = true;
				else if (I == 'br' && E) {
					C.add(new f.htmlParser.text('\n'));
					return;
				} else if (I == 'textarea')
					D = true;
				if (I == 'br') {
					B.push(M);
					return;
				}
				while (1) {
					var N = C.name,
					O = N ? k[N] || (C._.isBlockLike ? k.div : k.span) : t;
					if (!M.isUnknown && !C.isUnknown && !O[I]) {
						if (C.isOptionalClose)
							y.onTagClose(N);
						else if (I in s && N in s) {
							var P = C.children,
							Q = P[P.length - 1];
							if (!(Q && Q.name == 'li'))
								H(Q = new f.htmlParser.element('li'), C);
							!M.returnPoint && (M.returnPoint = C);
							C = Q;
						} else if (I in k.$listItem && N != I)
							y.onTagOpen(I == 'li' ? 'ul' : 'dl', {}, 0, 1);
						else if (N in q && N != I) {
							!M.returnPoint && (M.returnPoint = C);
							C = C.parent;
						} else {
							if (N in k.$inline)
								A.unshift(C);
							if (C.parent)
								H(C, C.parent, 1);
							else {
								M.isOrphan = 1;
								break;
							}
						}
					} else
						break;
				}
				F(I);
				G();
				M.parent = C;
				if (M.isEmpty)
					H(M);
				else
					C = M;
			};
			y.onTagClose = function (I) {
				for (var J = A.length - 1; J >= 0; J--) {
					if (I == A[J].name) {
						A.splice(J, 1);
						return;
					}
				}
				var K = [],
				L = [],
				M = C;
				while (M != z && M.name != I) {
					if (!M._.isBlockLike)
						L.unshift(M);
					K.push(M);
					M = M.returnPoint || M.parent;
				}
				if (M != z) {
					for (J = 0; J < K.length; J++) {
						var N = K[J];
						H(N, N.parent);
					}
					C = M;
					if (M._.isBlockLike)
						G();
					H(M, M.parent);
					if (M == C)
						C = C.parent;
					A = A.concat(L);
				}
				if (I == 'body')
					w = false;
			};
			y.onText = function (I) {
				if ((!C._.hasInlineStarted || B.length) && !E && !D) {
					I = j.ltrim(I);
					if (I.length === 0)
						return;
				}
				var J = C.name,
				K = J ? k[J] || (C._.isBlockLike ? k.div : k.span) : t;
				if (!D && !K['#'] && J in q) {
					y.onTagOpen(J in s ? 'li' : J == 'dl' ? 'dd' : J == 'table' ? 'tr' : J == 'tr' ? 'td' : '');
					y.onText(I);
					return;
				}
				G();
				F();
				if (w && (!C.type || C.name == 'body') && j.trim(I))
					this.onTagOpen(w, {}, 0, 1);
				if (!E && !D)
					I = I.replace(/[\t\r\n ]{2,}|[\t\r\n]/g, ' ');
				C.add(new f.htmlParser.text(I));
			};
			y.onCDATA = function (I) {
				C.add(new f.htmlParser.cdata(I));
			};
			y.onComment = function (I) {
				G();
				F();
				C.add(new f.htmlParser.comment(I));
			};
			y.parse(v);
			G(!h && 1);
			while (C != z)
				H(C, C.parent, 1);
			return z;
		};
		f.htmlParser.fragment.prototype = {
			add : function (v, w) {
				var y = this;
				isNaN(w) && (w = y.children.length);
				var x = w > 0 ? y.children[w - 1] : null;
				if (x) {
					if (v._.isBlockLike && x.type == 3) {
						x.value = j.rtrim(x.value);
						if (x.value.length === 0) {
							y.children.pop();
							y.add(v);
							return;
						}
					}
					x.next = v;
				}
				v.previous = x;
				v.parent = y;
				y.children.splice(w, 0, v);
				y._.hasInlineStarted = v.type == 3 || v.type == 1 && !v._.isBlockLike;
			},
			writeHtml : function (v, w) {
				var x;
				this.filterChildren = function () {
					var y = new f.htmlParser.basicWriter();
					this.writeChildrenHtml.call(this, y, w, true);
					var z = y.getHtml();
					this.children = new f.htmlParser.fragment.fromHtml(z).children;
					x = 1;
				};
				!this.name && w && w.onFragment(this);
				this.writeChildrenHtml(v, x ? null : w);
			},
			writeChildrenHtml : function (v, w) {
				for (var x = 0; x < this.children.length; x++)
					this.children[x].writeHtml(v, w);
			}
		};
	})();
	f.htmlParser.element = function (q, r) {
		var v = this;
		v.name = q;
		v.attributes = r || {};
		v.children = [];
		var s = q || '',
		t = s.match(/^cke:(.*)/);
		t && (s = t[1]);
		var u = !!(k.$nonBodyContent[s] || k.$block[s] || k.$listItem[s] || k.$tableContent[s] || k.$nonEditable[s] || s == 'br');
		v.isEmpty = !!k.$empty[q];
		v.isUnknown = !k[q];
		v._ = {
			isBlockLike : u,
			hasInlineStarted : v.isEmpty || !u
		};
	};
	f.htmlParser.cssStyle = function () {
		var q,
		r = arguments[0],
		s = {};
		q = r instanceof f.htmlParser.element ? r.attributes.style : r;
		(q || '').replace(/&quot;/g, '"').replace(/\s*([^ :;]+)\s*:\s*([^;]+)\s*(?=;|$)/g, function (t, u, v) {
			u == 'font-family' && (v = v.replace(/["']/g, ''));
			s[u.toLowerCase()] = v;
		});
		return {
			rules : s,
			populate : function (t) {
				var u = this.toString();
				if (u)
					t instanceof m ? t.setAttribute('style', u) : t instanceof f.htmlParser.element ? t.attributes.style = u : t.style = u;
			},
			'toString' : function () {
				var t = [];
				for (var u in s)
					s[u] && t.push(u, ':', s[u], ';');
				return t.join('');
			}
		};
	};
	(function () {
		var q = function (r, s) {
			r = r[0];
			s = s[0];
			return r < s ? -1 : r > s ? 1 : 0;
		};
		f.htmlParser.element.prototype = {
			type : 1,
			add : f.htmlParser.fragment.prototype.add,
			clone : function () {
				return new f.htmlParser.element(this.name, this.attributes);
			},
			writeHtml : function (r, s) {
				var t = this.attributes,
				u = this,
				v = u.name,
				w,
				x,
				y,
				z;
				u.filterChildren = function () {
					if (!z) {
						var G = new f.htmlParser.basicWriter();
						f.htmlParser.fragment.prototype.writeChildrenHtml.call(u, G, s);
						u.children = new f.htmlParser.fragment.fromHtml(G.getHtml(), 0, u.clone()).children;
						z = 1;
					}
				};
				if (s) {
					for (; ; ) {
						if (!(v = s.onElementName(v)))
							return;
						u.name = v;
						if (!(u = s.onElement(u)))
							return;
						u.parent = this.parent;
						if (u.name == v)
							break;
						if (u.type != 1) {
							u.writeHtml(r, s);
							return;
						}
						v = u.name;
						if (!v) {
							for (var A = 0, B = this.children.length; A < B; A++)
								this.children[A].parent = u.parent;
							this.writeChildrenHtml.call(u, r, z ? null : s);
							return;
						}
					}
					t = u.attributes;
				}
				r.openTag(v, t);
				var C = [];
				for (var D = 0; D < 2; D++)
					for (w in t) {
						x = w;
						y = t[w];
						if (D == 1)
							C.push([w, y]);
						else if (s) {
							for (; ; ) {
								if (!(x = s.onAttributeName(w))) {
									delete t[w];
									break;
								} else if (x != w) {
									delete t[w];
									w = x;
									continue;
								} else
									break;
							}
							if (x)
								if ((y = s.onAttribute(u, x, y)) === false)
									delete t[x];
								else
									t[x] = y;
						}
					}
				if (r.sortAttributes)
					C.sort(q);
				var E = C.length;
				for (D = 0; D < E; D++) {
					var F = C[D];
					r.attribute(F[0], F[1]);
				}
				r.openTagClose(v, u.isEmpty);
				if (!u.isEmpty) {
					this.writeChildrenHtml.call(u, r, z ? null : s);
					r.closeTag(v);
				}
			},
			writeChildrenHtml : function (r, s) {
				f.htmlParser.fragment.prototype.writeChildrenHtml.apply(this, arguments);
			}
		};
	})();
	(function () {
		f.htmlParser.filter = j.createClass({
				$ : function (v) {
					this._ = {
						elementNames : [],
						attributeNames : [],
						elements : {
							$length : 0
						},
						attributes : {
							$length : 0
						}
					};
					if (v)
						this.addRules(v, 10);
				},
				proto : {
					addRules : function (v, w) {
						var x = this;
						if (typeof w != 'number')
							w = 10;
						r(x._.elementNames, v.elementNames, w);
						r(x._.attributeNames, v.attributeNames, w);
						s(x._.elements, v.elements, w);
						s(x._.attributes, v.attributes, w);
						x._.text = t(x._.text, v.text, w) || x._.text;
						x._.comment = t(x._.comment, v.comment, w) || x._.comment;
						x._.root = t(x._.root, v.root, w) || x._.root;
					},
					onElementName : function (v) {
						return q(v, this._.elementNames);
					},
					onAttributeName : function (v) {
						return q(v, this._.attributeNames);
					},
					onText : function (v) {
						var w = this._.text;
						return w ? w.filter(v) : v;
					},
					onComment : function (v, w) {
						var x = this._.comment;
						return x ? x.filter(v, w) : v;
					},
					onFragment : function (v) {
						var w = this._.root;
						return w ? w.filter(v) : v;
					},
					onElement : function (v) {
						var A = this;
						var w = [A._.elements['^'], A._.elements[v.name], A._.elements.$],
						x,
						y;
						for (var z = 0; z < 3; z++) {
							x = w[z];
							if (x) {
								y = x.filter(v, A);
								if (y === false)
									return null;
								if (y && y != v)
									return A.onNode(y);
								if (v.parent && !v.name)
									break;
							}
						}
						return v;
					},
					onNode : function (v) {
						var w = v.type;
						return w == 1 ? this.onElement(v) : w == 3 ? new f.htmlParser.text(this.onText(v.value)) : w == 8 ? new f.htmlParser.comment(this.onComment(v.value)) : null;
					},
					onAttribute : function (v, w, x) {
						var y = this._.attributes[w];
						if (y) {
							var z = y.filter(x, v, this);
							if (z === false)
								return false;
							if (typeof z != 'undefined')
								return z;
						}
						return x;
					}
				}
			});
		function q(v, w) {
			for (var x = 0; v && x < w.length; x++) {
				var y = w[x];
				v = v.replace(y[0], y[1]);
			}
			return v;
		};
		function r(v, w, x) {
			if (typeof w == 'function')
				w = [w];
			var y,
			z,
			A = v.length,
			B = w && w.length;
			if (B) {
				for (y = 0; y < A && v[y].pri < x; y++) {}
				
				for (z = B - 1; z >= 0; z--) {
					var C = w[z];
					if (C) {
						C.pri = x;
						v.splice(y, 0, C);
					}
				}
			}
		};
		function s(v, w, x) {
			if (w)
				for (var y in w) {
					var z = v[y];
					v[y] = t(z, w[y], x);
					if (!z)
						v.$length++;
				}
		};
		function t(v, w, x) {
			if (w) {
				w.pri = x;
				if (v) {
					if (!v.splice) {
						if (v.pri > x)
							v = [w, v];
						else
							v = [v, w];
						v.filter = u;
					} else
						r(v, w, x);
					return v;
				} else {
					w.filter = w;
					return w;
				}
			}
		};
		function u(v) {
			var w = v.type || v instanceof f.htmlParser.fragment;
			for (var x = 0; x < this.length; x++) {
				if (w)
					var y = v.type, z = v.name;
				var A = this[x],
				B = A.apply(window, arguments);
				if (B === false)
					return B;
				if (w) {
					if (B && (B.name != z || B.type != y))
						return B;
				} else if (typeof B != 'string')
					return B;
				B != undefined && (v = B);
			}
			return v;
		};
	})();
	f.htmlParser.basicWriter = j.createClass({
			$ : function () {
				this._ = {
					output : []
				};
			},
			proto : {
				openTag : function (q, r) {
					this._.output.push('<', q);
				},
				openTagClose : function (q, r) {
					if (r)
						this._.output.push(' />');
					else
						this._.output.push('>');
				},
				attribute : function (q, r) {
					if (typeof r == 'string')
						r = j.htmlEncodeAttr(r);
					this._.output.push(' ', q, '="', r, '"');
				},
				closeTag : function (q) {
					this._.output.push('</', q, '>');
				},
				text : function (q) {
					this._.output.push(q);
				},
				comment : function (q) {
					this._.output.push('<!--', q, '-->');
				},
				write : function (q) {
					this._.output.push(q);
				},
				reset : function () {
					this._.output = [];
					this._.indent = false;
				},
				getHtml : function (q) {
					var r = this._.output.join('');
					if (q)
						this.reset();
					return r;
				}
			}
		});
	delete f.loadFullCore;
	f.instances = {};
	f.document = new l(document);
	f.add = function (q) {
		f.instances[q.name] = q;
		q.on('focus', function () {
			if (f.currentInstance != q) {
				f.currentInstance = q;
				f.fire('currentInstance');
			}
		});
		q.on('blur', function () {
			if (f.currentInstance == q) {
				f.currentInstance = null;
				f.fire('currentInstance');
			}
		});
	};
	f.remove = function (q) {
		delete f.instances[q.name];
	};
	f.on('instanceDestroyed', function () {
		if (j.isEmpty(this.instances))
			f.fire('reset');
	});
	f.TRISTATE_ON = 1;
	f.TRISTATE_OFF = 2;
	f.TRISTATE_DISABLED = 0;
	i.comment = function (q, r) {
		if (typeof q == 'string')
			q = (r ? r.$ : document).createComment(q);
		i.domObject.call(this, q);
	};
	i.comment.prototype = new i.node();
	j.extend(i.comment.prototype, {
		type : 8,
		getOuterHtml : function () {
			return '<!--' + this.$.nodeValue + '-->';
		}
	});
	(function () {
		var q = {
			address : 1,
			blockquote : 1,
			dl : 1,
			h1 : 1,
			h2 : 1,
			h3 : 1,
			h4 : 1,
			h5 : 1,
			h6 : 1,
			p : 1,
			pre : 1,
			li : 1,
			dt : 1,
			dd : 1,
			legend : 1,
			caption : 1
		},
		r = {
			body : 1,
			div : 1,
			table : 1,
			tbody : 1,
			tr : 1,
			td : 1,
			th : 1,
			form : 1,
			fieldset : 1
		},
		s = function (t) {
			var u = t.getChildren();
			for (var v = 0, w = u.count(); v < w; v++) {
				var x = u.getItem(v);
				if (x.type == 1 && k.$block[x.getName()])
					return true;
			}
			return false;
		};
		i.elementPath = function (t) {
			var z = this;
			var u = null,
			v = null,
			w = [],
			x = t;
			while (x) {
				if (x.type == 1) {
					if (!z.lastElement)
						z.lastElement = x;
					var y = x.getName();
					if (!v) {
						if (!u && q[y])
							u = x;
						if (r[y])
							if (!u && y == 'div' && !s(x))
								u = x;
							else
								v = x;
					}
					w.push(x);
					if (y == 'body')
						break;
				}
				x = x.getParent();
			}
			z.block = u;
			z.blockLimit = v;
			z.elements = w;
		};
	})();
	i.elementPath.prototype = {
		compare : function (q) {
			var r = this.elements,
			s = q && q.elements;
			if (!s || r.length != s.length)
				return false;
			for (var t = 0; t < r.length; t++) {
				if (!r[t].equals(s[t]))
					return false;
			}
			return true;
		},
		contains : function (q) {
			var r = this.elements;
			for (var s = 0; s < r.length; s++) {
				if (r[s].getName()in q)
					return r[s];
			}
			return null;
		}
	};
	i.text = function (q, r) {
		if (typeof q == 'string')
			q = (r ? r.$ : document).createTextNode(q);
		this.$ = q;
	};
	i.text.prototype = new i.node();
	j.extend(i.text.prototype, {
		type : 3,
		getLength : function () {
			return this.$.nodeValue.length;
		},
		getText : function () {
			return this.$.nodeValue;
		},
		setText : function (q) {
			this.$.nodeValue = q;
		},
		split : function (q) {
			var v = this;
			if (h && q == v.getLength()) {
				var r = v.getDocument().createText('');
				r.insertAfter(v);
				return r;
			}
			var s = v.getDocument(),
			t = new i.text(v.$.splitText(q), s);
			if (g.ie8) {
				var u = new i.text('', s);
				u.insertAfter(t);
				u.remove();
			}
			return t;
		},
		substring : function (q, r) {
			if (typeof r != 'number')
				return this.$.nodeValue.substr(q);
			else
				return this.$.nodeValue.substring(q, r);
		}
	});
	i.documentFragment = function (q) {
		q = q || f.document;
		this.$ = q.$.createDocumentFragment();
	};
	j.extend(i.documentFragment.prototype, m.prototype, {
		type : 11,
		insertAfterNode : function (q) {
			q = q.$;
			q.parentNode.insertBefore(this.$, q.nextSibling);
		}
	}, true, {
		append : 1,
		appendBogus : 1,
		getFirst : 1,
		getLast : 1,
		appendTo : 1,
		moveChildren : 1,
		insertBefore : 1,
		insertAfterNode : 1,
		replace : 1,
		trim : 1,
		type : 1,
		ltrim : 1,
		rtrim : 1,
		getDocument : 1,
		getChildCount : 1,
		getChild : 1,
		getChildren : 1
	});
	(function () {
		function q(x, y) {
			var z = this.range;
			if (this._.end)
				return null;
			if (!this._.start) {
				this._.start = 1;
				if (z.collapsed) {
					this.end();
					return null;
				}
				z.optimize();
			}
			var A,
			B = z.startContainer,
			C = z.endContainer,
			D = z.startOffset,
			E = z.endOffset,
			F,
			G = this.guard,
			H = this.type,
			I = x ? 'getPreviousSourceNode' : 'getNextSourceNode';
			if (!x && !this._.guardLTR) {
				var J = C.type == 1 ? C : C.getParent(),
				K = C.type == 1 ? C.getChild(E) : C.getNext();
				this._.guardLTR = function (O, P) {
					return (!P || !J.equals(O)) && (!K || !O.equals(K)) && (O.type != 1 || !P || O.getName() != 'body');
				};
			}
			if (x && !this._.guardRTL) {
				var L = B.type == 1 ? B : B.getParent(),
				M = B.type == 1 ? D ? B.getChild(D - 1) : null : B.getPrevious();
				this._.guardRTL = function (O, P) {
					return (!P || !L.equals(O)) && (!M || !O.equals(M)) && (O.type != 1 || !P || O.getName() != 'body');
				};
			}
			var N = x ? this._.guardRTL : this._.guardLTR;
			if (G)
				F = function (O, P) {
					if (N(O, P) === false)
						return false;
					return G(O, P);
				};
			else
				F = N;
			if (this.current)
				A = this.current[I](false, H, F);
			else {
				if (x) {
					A = C;
					if (A.type == 1)
						if (E > 0)
							A = A.getChild(E - 1);
						else
							A = F(A, true) === false ? null : A.getPreviousSourceNode(true, H, F);
				} else {
					A = B;
					if (A.type == 1)
						if (!(A = A.getChild(D)))
							A = F(B, true) === false ? null : B.getNextSourceNode(true, H, F);
				}
				if (A && F(A) === false)
					A = null;
			}
			while (A && !this._.end) {
				this.current = A;
				if (!this.evaluator || this.evaluator(A) !== false) {
					if (!y)
						return A;
				} else if (y && this.evaluator)
					return false;
				A = A[I](false, H, F);
			}
			this.end();
			return this.current = null;
		};
		function r(x) {
			var y,
			z = null;
			while (y = q.call(this, x))
				z = y;
			return z;
		};
		i.walker = j.createClass({
				$ : function (x) {
					this.range = x;
					this._ = {};
				},
				proto : {
					end : function () {
						this._.end = 1;
					},
					next : function () {
						return q.call(this);
					},
					previous : function () {
						return q.call(this, 1);
					},
					checkForward : function () {
						return q.call(this, 0, 1) !== false;
					},
					checkBackward : function () {
						return q.call(this, 1, 1) !== false;
					},
					lastForward : function () {
						return r.call(this);
					},
					lastBackward : function () {
						return r.call(this, 1);
					},
					reset : function () {
						delete this.current;
						this._ = {};
					}
				}
			});
		var s = {
			block : 1,
			'list-item' : 1,
			table : 1,
			'table-row-group' : 1,
			'table-header-group' : 1,
			'table-footer-group' : 1,
			'table-row' : 1,
			'table-column-group' : 1,
			'table-column' : 1,
			'table-cell' : 1,
			'table-caption' : 1
		};
		m.prototype.isBlockBoundary = function (x) {
			var y = x ? j.extend({}, k.$block, x || {}) : k.$block;
			return this.getComputedStyle('float') == 'none' && s[this.getComputedStyle('display')] || y[this.getName()];
		};
		i.walker.blockBoundary = function (x) {
			return function (y, z) {
				return !(y.type == 1 && y.isBlockBoundary(x));
			};
		};
		i.walker.listItemBoundary = function () {
			return this.blockBoundary({
				br : 1
			});
		};
		i.walker.bookmark = function (x, y) {
			function z(A) {
				return A && A.getName && A.getName() == 'span' && A.data('cke-bookmark');
			};
			return function (A) {
				var B,
				C;
				B = A && !A.getName && (C = A.getParent()) && z(C);
				B = x ? B : B || z(A);
				return !!(y^B);
			};
		};
		i.walker.whitespaces = function (x) {
			return function (y) {
				var z;
				if (y && y.type == 3)
					z = !j.trim(y.getText()) || g.webkit && y.getText() == '​';
				return !!(x^z);
			};
		};
		i.walker.invisible = function (x) {
			var y = i.walker.whitespaces();
			return function (z) {
				var A;
				if (y(z))
					A = 1;
				else {
					if (z.type == 3)
						z = z.getParent();
					A = !z.$.offsetHeight;
				}
				return !!(x^A);
			};
		};
		i.walker.nodeType = function (x, y) {
			return function (z) {
				return !!(y^z.type == x);
			};
		};
		i.walker.bogus = function (x) {
			function y(z) {
				return !u(z) && !v(z);
			};
			return function (z) {
				var A = !h ? z.is && z.is('br') : z.getText && t.test(z.getText());
				if (A) {
					var B = z.getParent(),
					C = z.getNext(y);
					A = B.isBlockBoundary() && (!C || C.type == 1 && C.isBlockBoundary());
				}
				return !!(x^A);
			};
		};
		var t = /^[\t\r\n ]*(?:&nbsp;|\xa0)$/,
		u = i.walker.whitespaces(),
		v = i.walker.bookmark(),
		w = function (x) {
			return v(x) || u(x) || x.type == 1 && x.getName()in k.$inline && !(x.getName()in k.$empty);
		};
		m.prototype.getBogus = function () {
			var x = this;
			do
				x = x.getPreviousSourceNode();
			while (w(x))
			if (x && (!h ? x.is && x.is('br') : x.getText && t.test(x.getText())))
				return x;
			return false;
		};
	})();
	i.range = function (q) {
		var r = this;
		r.startContainer = null;
		r.startOffset = null;
		r.endContainer = null;
		r.endOffset = null;
		r.collapsed = true;
		r.document = q;
	};
	(function () {
		var q = function (A) {
			A.collapsed = A.startContainer && A.endContainer && A.startContainer.equals(A.endContainer) && A.startOffset == A.endOffset;
		},
		r = function (A, B, C, D) {
			A.optimizeBookmark();
			var E = A.startContainer,
			F = A.endContainer,
			G = A.startOffset,
			H = A.endOffset,
			I,
			J;
			if (F.type == 3)
				F = F.split(H);
			else if (F.getChildCount() > 0)
				if (H >= F.getChildCount()) {
					F = F.append(A.document.createText(''));
					J = true;
				} else
					F = F.getChild(H);
			if (E.type == 3) {
				E.split(G);
				if (E.equals(F))
					F = E.getNext();
			} else if (!G) {
				E = E.getFirst().insertBeforeMe(A.document.createText(''));
				I = true;
			} else if (G >= E.getChildCount()) {
				E = E.append(A.document.createText(''));
				I = true;
			} else
				E = E.getChild(G).getPrevious();
			var K = E.getParents(),
			L = F.getParents(),
			M,
			N,
			O;
			for (M = 0; M < K.length; M++) {
				N = K[M];
				O = L[M];
				if (!N.equals(O))
					break;
			}
			var P = C,
			Q,
			R,
			S,
			T;
			for (var U = M; U < K.length; U++) {
				Q = K[U];
				if (P && !Q.equals(E))
					R = P.append(Q.clone());
				S = Q.getNext();
				while (S) {
					if (S.equals(L[U]) || S.equals(F))
						break;
					T = S.getNext();
					if (B == 2)
						P.append(S.clone(true));
					else {
						S.remove();
						if (B == 1)
							P.append(S);
					}
					S = T;
				}
				if (P)
					P = R;
			}
			P = C;
			for (var V = M; V < L.length; V++) {
				Q = L[V];
				if (B > 0 && !Q.equals(F))
					R = P.append(Q.clone());
				if (!K[V] || Q.$.parentNode != K[V].$.parentNode) {
					S = Q.getPrevious();
					while (S) {
						if (S.equals(K[V]) || S.equals(E))
							break;
						T = S.getPrevious();
						if (B == 2)
							P.$.insertBefore(S.$.cloneNode(true), P.$.firstChild);
						else {
							S.remove();
							if (B == 1)
								P.$.insertBefore(S.$, P.$.firstChild);
						}
						S = T;
					}
				}
				if (P)
					P = R;
			}
			if (B == 2) {
				var W = A.startContainer;
				if (W.type == 3) {
					W.$.data += W.$.nextSibling.data;
					W.$.parentNode.removeChild(W.$.nextSibling);
				}
				var X = A.endContainer;
				if (X.type == 3 && X.$.nextSibling) {
					X.$.data += X.$.nextSibling.data;
					X.$.parentNode.removeChild(X.$.nextSibling);
				}
			} else {
				if (N && O && (E.$.parentNode != N.$.parentNode || F.$.parentNode != O.$.parentNode)) {
					var Y = O.getIndex();
					if (I && O.$.parentNode == E.$.parentNode)
						Y--;
					if (D && N.type == 1) {
						var Z = m.createFromHtml('<span data-cke-bookmark="1" style="display:none">&nbsp;</span>', A.document);
						Z.insertAfter(N);
						N.mergeSiblings(false);
						A.moveToBookmark({
							startNode : Z
						});
					} else
						A.setStart(O.getParent(), Y);
				}
				A.collapse(true);
			}
			if (I)
				E.remove();
			if (J && F.$.parentNode)
				F.remove();
		},
		s = {
			abbr : 1,
			acronym : 1,
			b : 1,
			bdo : 1,
			big : 1,
			cite : 1,
			code : 1,
			del : 1,
			dfn : 1,
			em : 1,
			font : 1,
			i : 1,
			ins : 1,
			label : 1,
			kbd : 1,
			q : 1,
			samp : 1,
			small : 1,
			span : 1,
			strike : 1,
			strong : 1,
			sub : 1,
			sup : 1,
			tt : 1,
			u : 1,
			'var' : 1
		};
		function t() {
			var A = false,
			B = i.walker.whitespaces(),
			C = i.walker.bookmark(true),
			D = i.walker.bogus();
			return function (E) {
				if (C(E) || B(E))
					return true;
				if (D(E) && !A) {
					A = true;
					return true;
				}
				if (E.type == 3 && (E.hasAscendant('pre') || j.trim(E.getText()).length))
					return false;
				if (E.type == 1 && !s[E.getName()])
					return false;
				return true;
			};
		};
		var u = i.walker.bogus();
		function v(A) {
			var B = i.walker.whitespaces(),
			C = i.walker.bookmark(1);
			return function (D) {
				if (C(D) || B(D))
					return true;
				return !A && u(D) || D.type == 1 && D.getName()in k.$removeEmpty;
			};
		};
		var w = new i.walker.whitespaces(),
		x = new i.walker.bookmark(),
		y = /^[\t\r\n ]*(?:&nbsp;|\xa0)$/;
		function z(A) {
			return !w(A) && !x(A);
		};
		i.range.prototype = {
			clone : function () {
				var B = this;
				var A = new i.range(B.document);
				A.startContainer = B.startContainer;
				A.startOffset = B.startOffset;
				A.endContainer = B.endContainer;
				A.endOffset = B.endOffset;
				A.collapsed = B.collapsed;
				return A;
			},
			collapse : function (A) {
				var B = this;
				if (A) {
					B.endContainer = B.startContainer;
					B.endOffset = B.startOffset;
				} else {
					B.startContainer = B.endContainer;
					B.startOffset = B.endOffset;
				}
				B.collapsed = true;
			},
			cloneContents : function () {
				var A = new i.documentFragment(this.document);
				if (!this.collapsed)
					r(this, 2, A);
				return A;
			},
			deleteContents : function (A) {
				if (this.collapsed)
					return;
				r(this, 0, null, A);
			},
			extractContents : function (A) {
				var B = new i.documentFragment(this.document);
				if (!this.collapsed)
					r(this, 1, B, A);
				return B;
			},
			createBookmark : function (A) {
				var G = this;
				var B,
				C,
				D,
				E,
				F = G.collapsed;
				B = G.document.createElement('span');
				B.data('cke-bookmark', 1);
				B.setStyle('display', 'none');
				B.setHtml('&nbsp;');
				if (A) {
					D = 'cke_bm_' + j.getNextNumber();
					B.setAttribute('id', D + (F ? 'C' : 'S'));
				}
				if (!F) {
					C = B.clone();
					C.setHtml('&nbsp;');
					if (A)
						C.setAttribute('id', D + 'E');
					E = G.clone();
					E.collapse();
					E.insertNode(C);
				}
				E = G.clone();
				E.collapse(true);
				E.insertNode(B);
				if (C) {
					G.setStartAfter(B);
					G.setEndBefore(C);
				} else
					G.moveToPosition(B, 4);
				return {
					startNode : A ? D + (F ? 'C' : 'S') : B,
					endNode : A ? D + 'E' : C,
					serializable : A,
					collapsed : F
				};
			},
			createBookmark2 : function (A) {
				var I = this;
				var B = I.startContainer,
				C = I.endContainer,
				D = I.startOffset,
				E = I.endOffset,
				F = I.collapsed,
				G,
				H;
				if (!B || !C)
					return {
						start : 0,
						end : 0
					};
				if (A) {
					if (B.type == 1) {
						G = B.getChild(D);
						if (G && G.type == 3 && D > 0 && G.getPrevious().type == 3) {
							B = G;
							D = 0;
						}
						if (G && G.type == 1)
							D = G.getIndex(1);
					}
					while (B.type == 3 && (H = B.getPrevious()) && H.type == 3) {
						B = H;
						D += H.getLength();
					}
					if (!F) {
						if (C.type == 1) {
							G = C.getChild(E);
							if (G && G.type == 3 && E > 0 && G.getPrevious().type == 3) {
								C = G;
								E = 0;
							}
							if (G && G.type == 1)
								E = G.getIndex(1);
						}
						while (C.type == 3 && (H = C.getPrevious()) && H.type == 3) {
							C = H;
							E += H.getLength();
						}
					}
				}
				return {
					start : B.getAddress(A),
					end : F ? null : C.getAddress(A),
					startOffset : D,
					endOffset : E,
					normalized : A,
					collapsed : F,
					is2 : true
				};
			},
			moveToBookmark : function (A) {
				var I = this;
				if (A.is2) {
					var B = I.document.getByAddress(A.start, A.normalized),
					C = A.startOffset,
					D = A.end && I.document.getByAddress(A.end, A.normalized),
					E = A.endOffset;
					I.setStart(B, C);
					if (D)
						I.setEnd(D, E);
					else
						I.collapse(true);
				} else {
					var F = A.serializable,
					G = F ? I.document.getById(A.startNode) : A.startNode,
					H = F ? I.document.getById(A.endNode) : A.endNode;
					I.setStartBefore(G);
					G.remove();
					if (H) {
						I.setEndBefore(H);
						H.remove();
					} else
						I.collapse(true);
				}
			},
			getBoundaryNodes : function () {
				var F = this;
				var A = F.startContainer,
				B = F.endContainer,
				C = F.startOffset,
				D = F.endOffset,
				E;
				if (A.type == 1) {
					E = A.getChildCount();
					if (E > C)
						A = A.getChild(C);
					else if (E < 1)
						A = A.getPreviousSourceNode();
					else {
						A = A.$;
						while (A.lastChild)
							A = A.lastChild;
						A = new i.node(A);
						A = A.getNextSourceNode() || A;
					}
				}
				if (B.type == 1) {
					E = B.getChildCount();
					if (E > D)
						B = B.getChild(D).getPreviousSourceNode(true);
					else if (E < 1)
						B = B.getPreviousSourceNode();
					else {
						B = B.$;
						while (B.lastChild)
							B = B.lastChild;
						B = new i.node(B);
					}
				}
				if (A.getPosition(B) & 2)
					A = B;
				return {
					startNode : A,
					endNode : B
				};
			},
			getCommonAncestor : function (A, B) {
				var F = this;
				var C = F.startContainer,
				D = F.endContainer,
				E;
				if (C.equals(D)) {
					if (A && C.type == 1 && F.startOffset == F.endOffset - 1)
						E = C.getChild(F.startOffset);
					else
						E = C;
				} else
					E = C.getCommonAncestor(D);
				return B && !E.is ? E.getParent() : E;
			},
			optimize : function () {
				var C = this;
				var A = C.startContainer,
				B = C.startOffset;
				if (A.type != 1)
					if (!B)
						C.setStartBefore(A);
					else if (B >= A.getLength())
						C.setStartAfter(A);
				A = C.endContainer;
				B = C.endOffset;
				if (A.type != 1)
					if (!B)
						C.setEndBefore(A);
					else if (B >= A.getLength())
						C.setEndAfter(A);
			},
			optimizeBookmark : function () {
				var C = this;
				var A = C.startContainer,
				B = C.endContainer;
				if (A.is && A.is('span') && A.data('cke-bookmark'))
					C.setStartAt(A, 3);
				if (B && B.is && B.is('span') && B.data('cke-bookmark'))
					C.setEndAt(B, 4);
			},
			trim : function (A, B) {
				var I = this;
				var C = I.startContainer,
				D = I.startOffset,
				E = I.collapsed;
				if ((!A || E) && C && C.type == 3) {
					if (!D) {
						D = C.getIndex();
						C = C.getParent();
					} else if (D >= C.getLength()) {
						D = C.getIndex() + 1;
						C = C.getParent();
					} else {
						var F = C.split(D);
						D = C.getIndex() + 1;
						C = C.getParent();
						if (I.startContainer.equals(I.endContainer))
							I.setEnd(F, I.endOffset - I.startOffset);
						else if (C.equals(I.endContainer))
							I.endOffset += 1;
					}
					I.setStart(C, D);
					if (E) {
						I.collapse(true);
						return;
					}
				}
				var G = I.endContainer,
				H = I.endOffset;
				if (!(B || E) && G && G.type == 3) {
					if (!H) {
						H = G.getIndex();
						G = G.getParent();
					} else if (H >= G.getLength()) {
						H = G.getIndex() + 1;
						G = G.getParent();
					} else {
						G.split(H);
						H = G.getIndex() + 1;
						G = G.getParent();
					}
					I.setEnd(G, H);
				}
			},
			enlarge : function (A, B) {
				switch (A) {
				case 1:
					if (this.collapsed)
						return;
					var C = this.getCommonAncestor(),
					D = this.document.getBody(),
					E,
					F,
					G,
					H,
					I,
					J = false,
					K,
					L,
					M = this.startContainer,
					N = this.startOffset;
					if (M.type == 3) {
						if (N) {
							M = !j.trim(M.substring(0, N)).length && M;
							J = !!M;
						}
						if (M)
							if (!(H = M.getPrevious()))
								G = M.getParent();
					} else {
						if (N)
							H = M.getChild(N - 1) || M.getLast();
						if (!H)
							G = M;
					}
					while (G || H) {
						if (G && !H) {
							if (!I && G.equals(C))
								I = true;
							if (!D.contains(G))
								break;
							if (!J || G.getComputedStyle('display') != 'inline') {
								J = false;
								if (I)
									E = G;
								else
									this.setStartBefore(G);
							}
							H = G.getPrevious();
						}
						while (H) {
							K = false;
							if (H.type == 8) {
								H = H.getPrevious();
								continue;
							} else if (H.type == 3) {
								L = H.getText();
								if (/[^\s\ufeff]/.test(L))
									H = null;
								K = /[\s\ufeff]$/.test(L);
							} else if ((H.$.offsetWidth > 0 || B && H.is('br')) && !H.data('cke-bookmark'))
								if (J && k.$removeEmpty[H.getName()]) {
									L = H.getText();
									if (/[^\s\ufeff]/.test(L))
										H = null;
									else {
										var O = H.$.getElementsByTagName('*');
										for (var P = 0, Q; Q = O[P++]; ) {
											if (!k.$removeEmpty[Q.nodeName.toLowerCase()]) {
												H = null;
												break;
											}
										}
									}
									if (H)
										K = !!L.length;
								} else
									H = null;
							if (K)
								if (J) {
									if (I)
										E = G;
									else if (G)
										this.setStartBefore(G);
								} else
									J = true;
							if (H) {
								var R = H.getPrevious();
								if (!G && !R) {
									G = H;
									H = null;
									break;
								}
								H = R;
							} else
								G = null;
						}
						if (G)
							G = G.getParent();
					}
					M = this.endContainer;
					N = this.endOffset;
					G = H = null;
					I = J = false;
					if (M.type == 3) {
						M = !j.trim(M.substring(N)).length && M;
						J = !(M && M.getLength());
						if (M)
							if (!(H = M.getNext()))
								G = M.getParent();
					} else {
						H = M.getChild(N);
						if (!H)
							G = M;
					}
					while (G || H) {
						if (G && !H) {
							if (!I && G.equals(C))
								I = true;
							if (!D.contains(G))
								break;
							if (!J || G.getComputedStyle('display') != 'inline') {
								J = false;
								if (I)
									F = G;
								else if (G)
									this.setEndAfter(G);
							}
							H = G.getNext();
						}
						while (H) {
							K = false;
							if (H.type == 3) {
								L = H.getText();
								if (/[^\s\ufeff]/.test(L))
									H = null;
								K = /^[\s\ufeff]/.test(L);
							} else if (H.type == 1) {
								if ((H.$.offsetWidth > 0 || B && H.is('br')) && !H.data('cke-bookmark'))
									if (J && k.$removeEmpty[H.getName()]) {
										L = H.getText();
										if (/[^\s\ufeff]/.test(L))
											H = null;
										else {
											O = H.$.getElementsByTagName('*');
											for (P = 0; Q = O[P++]; ) {
												if (!k.$removeEmpty[Q.nodeName.toLowerCase()]) {
													H = null;
													break;
												}
											}
										}
										if (H)
											K = !!L.length;
									} else
										H = null;
							} else
								K = 1;
							if (K)
								if (J)
									if (I)
										F = G;
									else
										this.setEndAfter(G);
							if (H) {
								R = H.getNext();
								if (!G && !R) {
									G = H;
									H = null;
									break;
								}
								H = R;
							} else
								G = null;
						}
						if (G)
							G = G.getParent();
					}
					if (E && F) {
						C = E.contains(F) ? F : E;
						this.setStartBefore(C);
						this.setEndAfter(C);
					}
					break;
				case 2:
				case 3:
					var S = new i.range(this.document);
					D = this.document.getBody();
					S.setStartAt(D, 1);
					S.setEnd(this.startContainer, this.startOffset);
					var T = new i.walker(S),
					U,
					V,
					W = i.walker.blockBoundary(A == 3 ? {
							br : 1
						}
							 : null),
					X = function (ad) {
						var ae = W(ad);
						if (!ae)
							U = ad;
						return ae;
					},
					Y = function (ad) {
						var ae = X(ad);
						if (!ae && ad.is && ad.is('br'))
							V = ad;
						return ae;
					};
					T.guard = X;
					G = T.lastBackward();
					U = U || D;
					this.setStartAt(U, !U.is('br') && (!G && this.checkStartOfBlock() || G && U.contains(G)) ? 1 : 4);
					if (A == 3) {
						var Z = this.clone();
						T = new i.walker(Z);
						var aa = i.walker.whitespaces(),
						ab = i.walker.bookmark();
						T.evaluator = function (ad) {
							return !aa(ad) && !ab(ad);
						};
						var ac = T.previous();
						if (ac && ac.type == 1 && ac.is('br'))
							return;
					}
					S = this.clone();
					S.collapse();
					S.setEndAt(D, 2);
					T = new i.walker(S);
					T.guard = A == 3 ? Y : X;
					U = null;
					G = T.lastForward();
					U = U || D;
					this.setEndAt(U, !G && this.checkEndOfBlock() || G && U.contains(G) ? 2 : 3);
					if (V)
						this.setEndAfter(V);
				}
			},
			shrink : function (A, B) {
				if (!this.collapsed) {
					A = A || 2;
					var C = this.clone(),
					D = this.startContainer,
					E = this.endContainer,
					F = this.startOffset,
					G = this.endOffset,
					H = this.collapsed,
					I = 1,
					J = 1;
					if (D && D.type == 3)
						if (!F)
							C.setStartBefore(D);
						else if (F >= D.getLength())
							C.setStartAfter(D);
						else {
							C.setStartBefore(D);
							I = 0;
						}
					if (E && E.type == 3)
						if (!G)
							C.setEndBefore(E);
						else if (G >= E.getLength())
							C.setEndAfter(E);
						else {
							C.setEndAfter(E);
							J = 0;
						}
					var K = new i.walker(C),
					L = i.walker.bookmark();
					K.evaluator = function (P) {
						return P.type == (A == 1 ? 1 : 3);
					};
					var M;
					K.guard = function (P, Q) {
						if (L(P))
							return true;
						if (A == 1 && P.type == 3)
							return false;
						if (Q && P.equals(M))
							return false;
						if (!Q && P.type == 1)
							M = P;
						return true;
					};
					if (I) {
						var N = K[A == 1 ? 'lastForward' : 'next']();
						N && this.setStartAt(N, B ? 1 : 3);
					}
					if (J) {
						K.reset();
						var O = K[A == 1 ? 'lastBackward' : 'previous']();
						O && this.setEndAt(O, B ? 2 : 4);
					}
					return !!(I || J);
				}
			},
			insertNode : function (A) {
				var E = this;
				E.optimizeBookmark();
				E.trim(false, true);
				var B = E.startContainer,
				C = E.startOffset,
				D = B.getChild(C);
				if (D)
					A.insertBefore(D);
				else
					B.append(A);
				if (A.getParent().equals(E.endContainer))
					E.endOffset++;
				E.setStartBefore(A);
			},
			moveToPosition : function (A, B) {
				this.setStartAt(A, B);
				this.collapse(true);
			},
			selectNodeContents : function (A) {
				this.setStart(A, 0);
				this.setEnd(A, A.type == 3 ? A.getLength() : A.getChildCount());
			},
			setStart : function (A, B) {
				var C = this;
				if (A.type == 1 && k.$empty[A.getName()])
					B = A.getIndex(), A = A.getParent();
				C.startContainer = A;
				C.startOffset = B;
				if (!C.endContainer) {
					C.endContainer = A;
					C.endOffset = B;
				}
				q(C);
			},
			setEnd : function (A, B) {
				var C = this;
				if (A.type == 1 && k.$empty[A.getName()])
					B = A.getIndex() + 1, A = A.getParent();
				C.endContainer = A;
				C.endOffset = B;
				if (!C.startContainer) {
					C.startContainer = A;
					C.startOffset = B;
				}
				q(C);
			},
			setStartAfter : function (A) {
				this.setStart(A.getParent(), A.getIndex() + 1);
			},
			setStartBefore : function (A) {
				this.setStart(A.getParent(), A.getIndex());
			},
			setEndAfter : function (A) {
				this.setEnd(A.getParent(), A.getIndex() + 1);
			},
			setEndBefore : function (A) {
				this.setEnd(A.getParent(), A.getIndex());
			},
			setStartAt : function (A, B) {
				var C = this;
				switch (B) {
				case 1:
					C.setStart(A, 0);
					break;
				case 2:
					if (A.type == 3)
						C.setStart(A, A.getLength());
					else
						C.setStart(A, A.getChildCount());
					break;
				case 3:
					C.setStartBefore(A);
					break;
				case 4:
					C.setStartAfter(A);
				}
				q(C);
			},
			setEndAt : function (A, B) {
				var C = this;
				switch (B) {
				case 1:
					C.setEnd(A, 0);
					break;
				case 2:
					if (A.type == 3)
						C.setEnd(A, A.getLength());
					else
						C.setEnd(A, A.getChildCount());
					break;
				case 3:
					C.setEndBefore(A);
					break;
				case 4:
					C.setEndAfter(A);
				}
				q(C);
			},
			fixBlock : function (A, B) {
				var E = this;
				var C = E.createBookmark(),
				D = E.document.createElement(B);
				E.collapse(A);
				E.enlarge(2);
				E.extractContents().appendTo(D);
				D.trim();
				if (!h)
					D.appendBogus();
				E.insertNode(D);
				E.moveToBookmark(C);
				return D;
			},
			splitBlock : function (A) {
				var K = this;
				var B = new i.elementPath(K.startContainer),
				C = new i.elementPath(K.endContainer),
				D = B.blockLimit,
				E = C.blockLimit,
				F = B.block,
				G = C.block,
				H = null;
				if (!D.equals(E))
					return null;
				if (A != 'br') {
					if (!F) {
						F = K.fixBlock(true, A);
						G = new i.elementPath(K.endContainer).block;
					}
					if (!G)
						G = K.fixBlock(false, A);
				}
				var I = F && K.checkStartOfBlock(),
				J = G && K.checkEndOfBlock();
				K.deleteContents();
				if (F && F.equals(G))
					if (J) {
						H = new i.elementPath(K.startContainer);
						K.moveToPosition(G, 4);
						G = null;
					} else if (I) {
						H = new i.elementPath(K.startContainer);
						K.moveToPosition(F, 3);
						F = null;
					} else {
						G = K.splitElement(F);
						if (!h && !F.is('ul', 'ol'))
							F.appendBogus();
					}
				return {
					previousBlock : F,
					nextBlock : G,
					wasStartOfBlock : I,
					wasEndOfBlock : J,
					elementPath : H
				};
			},
			splitElement : function (A) {
				var D = this;
				if (!D.collapsed)
					return null;
				D.setEndAt(A, 2);
				var B = D.extractContents(),
				C = A.clone(false);
				B.appendTo(C);
				C.insertAfter(A);
				D.moveToPosition(A, 4);
				return C;
			},
			checkBoundaryOfElement : function (A, B) {
				var C = B == 1,
				D = this.clone();
				D.collapse(C);
				D[C ? 'setStartAt' : 'setEndAt'](A, C ? 1 : 2);
				var E = new i.walker(D);
				E.evaluator = v(C);
				return E[C ? 'checkBackward' : 'checkForward']();
			},
			checkStartOfBlock : function () {
				var G = this;
				var A = G.startContainer,
				B = G.startOffset;
				if (h && B && A.type == 3) {
					var C = j.ltrim(A.substring(0, B));
					if (y.test(C))
						G.trim(0, 1);
				}
				var D = new i.elementPath(G.startContainer),
				E = G.clone();
				E.collapse(true);
				E.setStartAt(D.block || D.blockLimit, 1);
				var F = new i.walker(E);
				F.evaluator = t();
				return F.checkBackward();
			},
			checkEndOfBlock : function () {
				var G = this;
				var A = G.endContainer,
				B = G.endOffset;
				if (h && A.type == 3) {
					var C = j.rtrim(A.substring(B));
					if (y.test(C))
						G.trim(1, 0);
				}
				var D = new i.elementPath(G.endContainer),
				E = G.clone();
				E.collapse(false);
				E.setEndAt(D.block || D.blockLimit, 2);
				var F = new i.walker(E);
				F.evaluator = t();
				return F.checkForward();
			},
			getPreviousNode : function (A, B, C) {
				var D = this.clone();
				D.collapse(1);
				D.setStartAt(C || this.document.getBody(), 1);
				var E = new i.walker(D);
				E.evaluator = A;
				E.guard = B;
				return E.previous();
			},
			getNextNode : function (A, B, C) {
				var D = this.clone();
				D.collapse();
				D.setEndAt(C || this.document.getBody(), 2);
				var E = new i.walker(D);
				E.evaluator = A;
				E.guard = B;
				return E.next();
			},
			checkReadOnly : (function () {
				function A(B, C) {
					while (B) {
						if (B.type == 1)
							if (B.getAttribute('contentEditable') == 'false' && !B.data('cke-editable'))
								return 0;
							else if (B.is('html') || B.getAttribute('contentEditable') == 'true' && (B.contains(C) || B.equals(C)))
								break;
						B = B.getParent();
					}
					return 1;
				};
				return function () {
					var B = this.startContainer,
					C = this.endContainer;
					return !(A(B, C) && A(C, B));
				};
			})(),
			moveToElementEditablePosition : function (A, B) {
				function C(E, F) {
					var G;
					if (E.type == 1 && E.isEditable(false))
						G = E[B ? 'getLast' : 'getFirst'](z);
					if (!F && !G)
						G = E[B ? 'getPrevious' : 'getNext'](z);
					return G;
				};
				if (A.type == 1 && !A.isEditable(false)) {
					this.moveToPosition(A, B ? 4 : 3);
					return true;
				}
				var D = 0;
				while (A) {
					if (A.type == 3) {
						if (B && this.checkEndOfBlock() && y.test(A.getText()))
							this.moveToPosition(A, 3);
						else
							this.moveToPosition(A, B ? 4 : 3);
						D = 1;
						break;
					}
					if (A.type == 1)
						if (A.isEditable()) {
							this.moveToPosition(A, B ? 2 : 1);
							D = 1;
						} else if (B && A.is('br') && this.checkEndOfBlock())
							this.moveToPosition(A, 3);
					A = C(A, D);
				}
				return !!D;
			},
			moveToElementEditStart : function (A) {
				return this.moveToElementEditablePosition(A);
			},
			moveToElementEditEnd : function (A) {
				return this.moveToElementEditablePosition(A, true);
			},
			getEnclosedNode : function () {
				var A = this.clone();
				A.optimize();
				if (A.startContainer.type != 1 || A.endContainer.type != 1)
					return null;
				var B = new i.walker(A),
				C = i.walker.bookmark(true),
				D = i.walker.whitespaces(true),
				E = function (G) {
					return D(G) && C(G);
				};
				A.evaluator = E;
				var F = B.next();
				B.reset();
				return F && F.equals(B.previous()) ? F : null;
			},
			getTouchedStartNode : function () {
				var A = this.startContainer;
				if (this.collapsed || A.type != 1)
					return A;
				return A.getChild(this.startOffset) || A;
			},
			getTouchedEndNode : function () {
				var A = this.endContainer;
				if (this.collapsed || A.type != 1)
					return A;
				return A.getChild(this.endOffset - 1) || A;
			}
		};
	})();
	f.POSITION_AFTER_START = 1;
	f.POSITION_BEFORE_END = 2;
	f.POSITION_BEFORE_START = 3;
	f.POSITION_AFTER_END = 4;
	f.ENLARGE_ELEMENT = 1;
	f.ENLARGE_BLOCK_CONTENTS = 2;
	f.ENLARGE_LIST_ITEM_CONTENTS = 3;
	f.START = 1;
	f.END = 2;
	f.STARTEND = 3;
	f.SHRINK_ELEMENT = 1;
	f.SHRINK_TEXT = 2;
	(function () {
		i.rangeList = function (s) {
			if (s instanceof i.rangeList)
				return s;
			if (!s)
				s = [];
			else if (s instanceof i.range)
				s = [s];
			return j.extend(s, q);
		};
		var q = {
			createIterator : function () {
				var s = this,
				t = i.walker.bookmark(),
				u = function (x) {
					return !(x.is && x.is('tr'));
				},
				v = [],
				w;
				return {
					getNextRange : function (x) {
						w = w == undefined ? 0 : w + 1;
						var y = s[w];
						if (y && s.length > 1) {
							if (!w)
								for (var z = s.length - 1; z >= 0; z--)
									v.unshift(s[z].createBookmark(true));
							if (x) {
								var A = 0;
								while (s[w + A + 1]) {
									var B = y.document,
									C = 0,
									D = B.getById(v[A].endNode),
									E = B.getById(v[A + 1].startNode),
									F;
									while (1) {
										F = D.getNextSourceNode(false);
										if (!E.equals(F)) {
											if (t(F) || F.type == 1 && F.isBlockBoundary()) {
												D = F;
												continue;
											}
										} else
											C = 1;
										break;
									}
									if (!C)
										break;
									A++;
								}
							}
							y.moveToBookmark(v.shift());
							while (A--) {
								F = s[++w];
								F.moveToBookmark(v.shift());
								y.setEnd(F.endContainer, F.endOffset);
							}
						}
						return y;
					}
				};
			},
			createBookmarks : function (s) {
				var x = this;
				var t = [],
				u;
				for (var v = 0; v < x.length; v++) {
					t.push(u = x[v].createBookmark(s, true));
					for (var w = v + 1; w < x.length; w++) {
						x[w] = r(u, x[w]);
						x[w] = r(u, x[w], true);
					}
				}
				return t;
			},
			createBookmarks2 : function (s) {
				var t = [];
				for (var u = 0; u < this.length; u++)
					t.push(this[u].createBookmark2(s));
				return t;
			},
			moveToBookmarks : function (s) {
				for (var t = 0; t < this.length; t++)
					this[t].moveToBookmark(s[t]);
			}
		};
		function r(s, t, u) {
			var v = s.serializable,
			w = t[u ? 'endContainer' : 'startContainer'],
			x = u ? 'endOffset' : 'startOffset',
			y = v ? t.document.getById(s.startNode) : s.startNode,
			z = v ? t.document.getById(s.endNode) : s.endNode;
			if (w.equals(y.getPrevious())) {
				t.startOffset = t.startOffset - w.getLength() - z.getPrevious().getLength();
				w = z.getNext();
			} else if (w.equals(z.getPrevious())) {
				t.startOffset = t.startOffset - w.getLength();
				w = z.getNext();
			}
			w.equals(y.getParent()) && t[x]++;
			w.equals(z.getParent()) && t[x]++;
			t[u ? 'endContainer' : 'startContainer'] = w;
			return t;
		};
	})();
	(function () {
		if (g.webkit) {
			g.hc = false;
			return;
		}
		var q = m.createFromHtml('<div style="width:0px;height:0px;position:absolute;left:-10000px;border: 1px solid;border-color: red blue;"></div>', f.document);
		q.appendTo(f.document.getHead());
		try {
			g.hc = q.getComputedStyle('border-top-color') == q.getComputedStyle('border-right-color');
		} catch (r) {
			g.hc = false;
		}
		if (g.hc)
			g.cssClass += ' cke_hc';
		q.remove();
	})();
	o.load(n.corePlugins.split(','), function () {
		f.status = 'loaded';
		f.fire('loaded');
		var q = f._.pending;
		if (q) {
			delete f._.pending;
			for (var r = 0; r < q.length; r++)
				f.add(q[r]);
		}
	});
	if (h)
		try {
			document.execCommand('BackgroundImageCache', false, true);
		} catch (q) {}
		
	f.skins.add('kama', (function () {
			var r = 'cke_ui_color';
			return {
				editor : {
					css : ['editor.css']
				},
				dialog : {
					css : ['dialog.css']
				},
				templates : {
					css : ['templates.css']
				},
				margins : [0, 0, 0, 0],
				init : function (s) {
					if (s.config.width && !isNaN(s.config.width))
						s.config.width -= 12;
					var t = [],
					u = /\$color/g,
					v = '/* UI Color Support */.cke_skin_kama .cke_menuitem .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a:focus .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a:active .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover .cke_label,.cke_skin_kama .cke_menuitem a:focus .cke_label,.cke_skin_kama .cke_menuitem a:active .cke_label{\tbackground-color: $color !important;}.cke_skin_kama .cke_menuitem a.cke_disabled:hover .cke_label,.cke_skin_kama .cke_menuitem a.cke_disabled:focus .cke_label,.cke_skin_kama .cke_menuitem a.cke_disabled:active .cke_label{\tbackground-color: transparent !important;}.cke_skin_kama .cke_menuitem a.cke_disabled:hover .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a.cke_disabled:focus .cke_icon_wrapper,.cke_skin_kama .cke_menuitem a.cke_disabled:active .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuitem a.cke_disabled .cke_icon_wrapper{\tbackground-color: $color !important;\tborder-color: $color !important;}.cke_skin_kama .cke_menuseparator{\tbackground-color: $color !important;}.cke_skin_kama .cke_menuitem a:hover,.cke_skin_kama .cke_menuitem a:focus,.cke_skin_kama .cke_menuitem a:active{\tbackground-color: $color !important;}';
					if (g.webkit) {
						v = v.split('}').slice(0, -1);
						for (var w = 0; w < v.length; w++)
							v[w] = v[w].split('{');
					}
					function x(A) {
						var B = A.getById(r);
						if (!B) {
							B = A.getHead().append('style');
							B.setAttribute('id', r);
							B.setAttribute('type', 'text/css');
						}
						return B;
					};
					function y(A, B, C) {
						var D,
						E,
						F;
						for (var G = 0; G < A.length; G++) {
							if (g.webkit)
								for (E = 0; E < B.length; E++) {
									F = B[E][1];
									for (D = 0; D < C.length; D++)
										F = F.replace(C[D][0], C[D][1]);
									A[G].$.sheet.addRule(B[E][0], F);
								}
							else {
								F = B;
								for (D = 0; D < C.length; D++)
									F = F.replace(C[D][0], C[D][1]);
								if (h)
									A[G].$.styleSheet.cssText += F;
								else
									A[G].$.innerHTML += F;
							}
						}
					};
					var z = /\$color/g;
					j.extend(s, {
						uiColor : null,
						getUiColor : function () {
							return this.uiColor;
						},
						setUiColor : function (A) {
							var B,
							C = x(f.document),
							D = '.' + s.id,
							E = [D + ' .cke_wrapper', D + '_dialog a.cke_dialog_tab', D + '_dialog .cke_dialog_footer'].join(','),
							F = 'background-color: $color !important;';
							if (g.webkit)
								B = [[E, F]];
							else
								B = E + '{' + F + '}';
							return (this.setUiColor = function (G) {
								var H = [[z, G]];
								s.uiColor = G;
								y([C], B, H);
								y(t, v, H);
							})(A);
						}
					});
					s.on('menuShow', function (A) {
						var B = A.data[0],
						C = B.element.getElementsByTag('iframe').getItem(0).getFrameDocument();
						if (!C.getById('cke_ui_color')) {
							var D = x(C);
							t.push(D);
							var E = s.getUiColor();
							if (E)
								y([D], v, [[z, E]]);
						}
					});
					if (s.config.uiColor)
						s.setUiColor(s.config.uiColor);
				}
			};
		})());
	(function () {
		f.dialog ? r() : f.on('dialogPluginReady', r);
		function r() {
			f.dialog.on('resize', function (s) {
				var t = s.data,
				u = t.width,
				v = t.height,
				w = t.dialog,
				x = w.parts.contents;
				if (t.skin != 'kama')
					return;
				x.setStyles({
					width : u + 'px',
					height : v + 'px'
				});
				setTimeout(function () {
					var y = w.parts.dialog.getChild([0, 0, 0]),
					z = y.getChild(0),
					A = y.getChild(2);
					A.setStyle('width', z.$.offsetWidth + 'px');
					A = y.getChild(7);
					A.setStyle('width', z.$.offsetWidth - 28 + 'px');
					A = y.getChild(4);
					A.setStyle('height', v + z.getChild(0).$.offsetHeight + 'px');
					A = y.getChild(5);
					A.setStyle('height', v + z.getChild(0).$.offsetHeight + 'px');
				}, 100);
			});
		};
	})();
	o.add('about', {
		requires : ['dialog'],
		init : function (r) {
			var s = r.addCommand('about', new f.dialogCommand('about'));
			s.modes = {
				wysiwyg : 1,
				source : 1
			};
			s.canUndo = false;
			s.readOnly = 1;
			r.ui.addButton('About', {
				label : r.lang.about.title,
				command : 'about'
			});
			f.dialog.add('about', this.path + 'dialogs/about.js');
		}
	});
	o.add('basicstyles', {
		requires : ['styles', 'button'],
		init : function (r) {
			var s = function (v, w, x, y) {
				var z = new f.style(y);
				r.attachStyleStateChange(z, function (A) {
					!r.readOnly && r.getCommand(x).setState(A);
				});
				r.addCommand(x, new f.styleCommand(z));
				r.ui.addButton(v, {
					label : w,
					command : x
				});
			},
			t = r.config,
			u = r.lang;
			s('Bold', u.bold, 'bold', t.coreStyles_bold);
			s('Italic', u.italic, 'italic', t.coreStyles_italic);
			s('Underline', u.underline, 'underline', t.coreStyles_underline);
			s('Strike', u.strike, 'strike', t.coreStyles_strike);
			s('Subscript', u.subscript, 'subscript', t.coreStyles_subscript);
			s('Superscript', u.superscript, 'superscript', t.coreStyles_superscript);
		}
	});
	n.coreStyles_bold = {
		element : 'strong',
		overrides : 'b'
	};
	n.coreStyles_italic = {
		element : 'em',
		overrides : 'i'
	};
	n.coreStyles_underline = {
		element : 'u'
	};
	n.coreStyles_strike = {
		element : 'strike'
	};
	n.coreStyles_subscript = {
		element : 'sub'
	};
	n.coreStyles_superscript = {
		element : 'sup'
	};
	(function () {
		var r = {
			table : 1,
			ul : 1,
			ol : 1,
			blockquote : 1,
			div : 1
		},
		s = {},
		t = {};
		j.extend(s, r, {
			tr : 1,
			p : 1,
			div : 1,
			li : 1
		});
		j.extend(t, s, {
			td : 1
		});
		function u(G) {
			v(G);
			w(G);
		};
		function v(G) {
			var H = G.editor,
			I = G.data.path;
			if (H.readOnly)
				return;
			var J = H.config.useComputedState,
			K;
			J = J === undefined || J;
			if (!J)
				K = x(I.lastElement);
			K = K || I.block || I.blockLimit;
			if (K.is('body')) {
				var L = H.getSelection().getRanges()[0].getEnclosedNode();
				L && L.type == 1 && (K = L);
			}
			if (!K)
				return;
			var M = J ? K.getComputedStyle('direction') : K.getStyle('direction') || K.getAttribute('dir');
			H.getCommand('bidirtl').setState(M == 'rtl' ? 1 : 2);
			H.getCommand('bidiltr').setState(M == 'ltr' ? 1 : 2);
		};
		function w(G) {
			var H = G.editor,
			I = G.data.path.block || G.data.path.blockLimit;
			H.fire('contentDirChanged', I ? I.getComputedStyle('direction') : H.lang.dir);
		};
		function x(G) {
			while (G && !(G.getName()in t || G.is('body'))) {
				var H = G.getParent();
				if (!H)
					break;
				G = H;
			}
			return G;
		};
		function y(G, H, I, J) {
			if (G.isReadOnly())
				return;
			m.setMarker(J, G, 'bidi_processed', 1);
			var K = G;
			while ((K = K.getParent()) && !K.is('body')) {
				if (K.getCustomData('bidi_processed')) {
					G.removeStyle('direction');
					G.removeAttribute('dir');
					return;
				}
			}
			var L = 'useComputedState' in I.config ? I.config.useComputedState : 1,
			M = L ? G.getComputedStyle('direction') : G.getStyle('direction') || G.hasAttribute('dir');
			if (M == H)
				return;
			G.removeStyle('direction');
			if (L) {
				G.removeAttribute('dir');
				if (H != G.getComputedStyle('direction'))
					G.setAttribute('dir', H);
			} else
				G.setAttribute('dir', H);
			I.forceNextSelectionCheck();
		};
		function z(G, H, I) {
			var J = G.getCommonAncestor(false, true);
			G = G.clone();
			G.enlarge(I == 2 ? 3 : 2);
			if (G.checkBoundaryOfElement(J, 1) && G.checkBoundaryOfElement(J, 2)) {
				var K;
				while (J && J.type == 1 && (K = J.getParent()) && K.getChildCount() == 1 && !(J.getName()in H))
					J = K;
				return J.type == 1 && J.getName()in H && J;
			}
		};
		function A(G) {
			return function (H) {
				var I = H.getSelection(),
				J = H.config.enterMode,
				K = I.getRanges();
				if (K && K.length) {
					var L = {},
					M = I.createBookmarks(),
					N = K.createIterator(),
					O,
					P = 0;
					while (O = N.getNextRange(1)) {
						var Q = O.getEnclosedNode();
						if (!Q || Q && !(Q.type == 1 && Q.getName()in s))
							Q = z(O, r, J);
						Q && y(Q, G, H, L);
						var R,
						S,
						T = new i.walker(O),
						U = M[P].startNode,
						V = M[P++].endNode;
						T.evaluator = function (W) {
							return !!(W.type == 1 && W.getName()in r && !(W.getName() == (J == 1 ? 'p' : 'div') && W.getParent().type == 1 && W.getParent().getName() == 'blockquote') && W.getPosition(U) & 2 && (W.getPosition(V) & 4 + 16) == 4);
						};
						while (S = T.next())
							y(S, G, H, L);
						R = O.createIterator();
						R.enlargeBr = J != 2;
						while (S = R.getNextParagraph(J == 1 ? 'p' : 'div'))
							y(S, G, H, L);
					}
					m.clearAllMarkers(L);
					H.forceNextSelectionCheck();
					I.selectBookmarks(M);
					H.focus();
				}
			};
		};
		o.add('bidi', {
			requires : ['styles', 'button'],
			init : function (G) {
				var H = function (J, K, L, M) {
					G.addCommand(L, new f.command(G, {
							exec : M
						}));
					G.ui.addButton(J, {
						label : K,
						command : L
					});
				},
				I = G.lang.bidi;
				H('BidiLtr', I.ltr, 'bidiltr', A('ltr'));
				H('BidiRtl', I.rtl, 'bidirtl', A('rtl'));
				G.on('selectionChange', u);
				G.on('contentDom', function () {
					G.document.on('dirChanged', function (J) {
						G.fire('dirChanged', {
							node : J.data,
							dir : J.data.getDirection(1)
						});
					});
				});
			}
		});
		function B(G) {
			var H = G.getDocument().getBody().getParent();
			while (G) {
				if (G.equals(H))
					return false;
				G = G.getParent();
			}
			return true;
		};
		function C(G) {
			var H = G == D.setAttribute,
			I = G == D.removeAttribute,
			J = /\bdirection\s*:\s*(.*?)\s*(:?$|;)/;
			return function (K, L) {
				var O = this;
				if (!O.getDocument().equals(f.document)) {
					var M;
					if ((K == (H || I ? 'dir' : 'direction') || K == 'style' && (I || J.test(L))) && !B(O)) {
						M = O.getDirection(1);
						var N = G.apply(O, arguments);
						if (M != O.getDirection(1)) {
							O.getDocument().fire('dirChanged', O);
							return N;
						}
					}
				}
				return G.apply(O, arguments);
			};
		};
		var D = m.prototype,
		E = ['setStyle', 'removeStyle', 'setAttribute', 'removeAttribute'];
		for (var F = 0; F < E.length; F++)
			D[E[F]] = j.override(D[E[F]], C);
	})();
	(function () {
		function r(v, w) {
			var x = w.block || w.blockLimit;
			if (!x || x.getName() == 'body')
				return 2;
			if (x.getAscendant('blockquote', true))
				return 1;
			return 2;
		};
		function s(v) {
			var w = v.editor;
			if (w.readOnly)
				return;
			var x = w.getCommand('blockquote');
			x.state = r(w, v.data.path);
			x.fire('state');
		};
		function t(v) {
			for (var w = 0, x = v.getChildCount(), y; w < x && (y = v.getChild(w)); w++) {
				if (y.type == 1 && y.isBlockBoundary())
					return false;
			}
			return true;
		};
		var u = {
			exec : function (v) {
				var w = v.getCommand('blockquote').state,
				x = v.getSelection(),
				y = x && x.getRanges(true)[0];
				if (!y)
					return;
				var z = x.createBookmarks();
				if (h) {
					var A = z[0].startNode,
					B = z[0].endNode,
					C;
					if (A && A.getParent().getName() == 'blockquote') {
						C = A;
						while (C = C.getNext()) {
							if (C.type == 1 && C.isBlockBoundary()) {
								A.move(C, true);
								break;
							}
						}
					}
					if (B && B.getParent().getName() == 'blockquote') {
						C = B;
						while (C = C.getPrevious()) {
							if (C.type == 1 && C.isBlockBoundary()) {
								B.move(C);
								break;
							}
						}
					}
				}
				var D = y.createIterator(),
				E;
				D.enlargeBr = v.config.enterMode != 2;
				if (w == 2) {
					var F = [];
					while (E = D.getNextParagraph())
						F.push(E);
					if (F.length < 1) {
						var G = v.document.createElement(v.config.enterMode == 1 ? 'p' : 'div'),
						H = z.shift();
						y.insertNode(G);
						G.append(new i.text('\ufeff', v.document));
						y.moveToBookmark(H);
						y.selectNodeContents(G);
						y.collapse(true);
						H = y.createBookmark();
						F.push(G);
						z.unshift(H);
					}
					var I = F[0].getParent(),
					J = [];
					for (var K = 0; K < F.length; K++) {
						E = F[K];
						I = I.getCommonAncestor(E.getParent());
					}
					var L = {
						table : 1,
						tbody : 1,
						tr : 1,
						ol : 1,
						ul : 1
					};
					while (L[I.getName()])
						I = I.getParent();
					var M = null;
					while (F.length > 0) {
						E = F.shift();
						while (!E.getParent().equals(I))
							E = E.getParent();
						if (!E.equals(M))
							J.push(E);
						M = E;
					}
					while (J.length > 0) {
						E = J.shift();
						if (E.getName() == 'blockquote') {
							var N = new i.documentFragment(v.document);
							while (E.getFirst()) {
								N.append(E.getFirst().remove());
								F.push(N.getLast());
							}
							N.replace(E);
						} else
							F.push(E);
					}
					var O = v.document.createElement('blockquote');
					O.insertBefore(F[0]);
					while (F.length > 0) {
						E = F.shift();
						O.append(E);
					}
				} else if (w == 1) {
					var P = [],
					Q = {};
					while (E = D.getNextParagraph()) {
						var R = null,
						S = null;
						while (E.getParent()) {
							if (E.getParent().getName() == 'blockquote') {
								R = E.getParent();
								S = E;
								break;
							}
							E = E.getParent();
						}
						if (R && S && !S.getCustomData('blockquote_moveout')) {
							P.push(S);
							m.setMarker(Q, S, 'blockquote_moveout', true);
						}
					}
					m.clearAllMarkers(Q);
					var T = [],
					U = [];
					Q = {};
					while (P.length > 0) {
						var V = P.shift();
						O = V.getParent();
						if (!V.getPrevious())
							V.remove().insertBefore(O);
						else if (!V.getNext())
							V.remove().insertAfter(O);
						else {
							V.breakParent(V.getParent());
							U.push(V.getNext());
						}
						if (!O.getCustomData('blockquote_processed')) {
							U.push(O);
							m.setMarker(Q, O, 'blockquote_processed', true);
						}
						T.push(V);
					}
					m.clearAllMarkers(Q);
					for (K = U.length - 1; K >= 0; K--) {
						O = U[K];
						if (t(O))
							O.remove();
					}
					if (v.config.enterMode == 2) {
						var W = true;
						while (T.length) {
							V = T.shift();
							if (V.getName() == 'div') {
								N = new i.documentFragment(v.document);
								var X = W && V.getPrevious() && !(V.getPrevious().type == 1 && V.getPrevious().isBlockBoundary());
								if (X)
									N.append(v.document.createElement('br'));
								var Y = V.getNext() && !(V.getNext().type == 1 && V.getNext().isBlockBoundary());
								while (V.getFirst())
									V.getFirst().remove().appendTo(N);
								if (Y)
									N.append(v.document.createElement('br'));
								N.replace(V);
								W = false;
							}
						}
					}
				}
				x.selectBookmarks(z);
				v.focus();
			}
		};
		o.add('blockquote', {
			init : function (v) {
				v.addCommand('blockquote', u);
				v.ui.addButton('Blockquote', {
					label : v.lang.blockquote,
					command : 'blockquote'
				});
				v.on('selectionChange', s);
			},
			requires : ['domiterator']
		});
	})();
	o.add('button', {
		beforeInit : function (r) {
			r.ui.addHandler(1, p.button.handler);
		}
	});
	f.UI_BUTTON = 'button';
	p.button = function (r) {
		j.extend(this, r, {
			title : r.label,
			className : r.className || r.command && 'cke_button_' + r.command || '',
			click : r.click || (function (s) {
				s.execCommand(r.command);
			})
		});
		this._ = {};
	};
	p.button.handler = {
		create : function (r) {
			return new p.button(r);
		}
	};
	(function () {
		p.button.prototype = {
			render : function (r, s) {
				var t = g,
				u = this._.id = j.getNextId(),
				v = '',
				w = this.command,
				x;
				this._.editor = r;
				var y = {
					id : u,
					button : this,
					editor : r,
					focus : function () {
						var E = f.document.getById(u);
						E.focus();
					},
					execute : function () {
						if (h && g.version < 7)
							j.setTimeout(function () {
								this.button.click(r);
							}, 0, this);
						else
							this.button.click(r);
					}
				},
				z = j.addFunction(function (E) {
						if (y.onkey) {
							E = new i.event(E);
							return y.onkey(y, E.getKeystroke()) !== false;
						}
					}),
				A = j.addFunction(function (E) {
						var F;
						if (y.onfocus)
							F = y.onfocus(y, new i.event(E)) !== false;
						if (g.gecko && g.version < 10900)
							E.preventBubble();
						return F;
					});
				y.clickFn = x = j.addFunction(y.execute, y);
				if (this.modes) {
					var B = {};
					function C() {
						var E = r.mode;
						if (E) {
							var F = this.modes[E] ? B[E] != undefined ? B[E] : 2 : 0;
							this.setState(r.readOnly && !this.readOnly ? 0 : F);
						}
					};
					r.on('beforeModeUnload', function () {
						if (r.mode && this._.state != 0)
							B[r.mode] = this._.state;
					}, this);
					r.on('mode', C, this);
					!this.readOnly && r.on('readOnly', C, this);
				} else if (w) {
					w = r.getCommand(w);
					if (w) {
						w.on('state', function () {
							this.setState(w.state);
						}, this);
						v += 'cke_' + (w.state == 1 ? 'on' : w.state == 0 ? 'disabled' : 'off');
					}
				}
				if (!w)
					v += 'cke_off';
				if (this.className)
					v += ' ' + this.className;
				s.push('<span class="cke_button' + (this.icon && this.icon.indexOf('.png') == -1 ? ' cke_noalphafix' : '') + '">', '<a id="', u, '" class="', v, '"', t.gecko && t.version >= 10900 && !t.hc ? '' : '" href="javascript:void(\'' + (this.title || '').replace("'", '') + "')\"", ' title="', this.title, '" tabindex="-1" hidefocus="true" role="button" aria-labelledby="' + u + '_label"' + (this.hasArrow ? ' aria-haspopup="true"' : ''));
				if (t.opera || t.gecko && t.mac)
					s.push(' onkeypress="return false;"');
				if (t.gecko)
					s.push(' onblur="this.style.cssText = this.style.cssText;"');
				s.push(' onkeydown="return CKEDITOR.tools.callFunction(', z, ', event);" onfocus="return CKEDITOR.tools.callFunction(', A, ', event);" ' + (h ? 'onclick="return false;" onmouseup' : 'onclick') + '="CKEDITOR.tools.callFunction(', x, ', this); return false;"><span class="cke_icon"');
				if (this.icon) {
					var D = (this.iconOffset || 0) * -16;
					s.push(' style="background-image:url(', f.getUrl(this.icon), ');background-position:0 ' + D + 'px;"');
				}
				s.push('>&nbsp;</span><span id="', u, '_label" class="cke_label">', this.label, '</span>');
				if (this.hasArrow)
					s.push('<span class="cke_buttonarrow">' + (g.hc ? '&#9660;' : '&nbsp;') + '</span>');
				s.push('</a>', '</span>');
				if (this.onRender)
					this.onRender();
				return y;
			},
			setState : function (r) {
				if (this._.state == r)
					return false;
				this._.state = r;
				var s = f.document.getById(this._.id);
				if (s) {
					s.setState(r);
					r == 0 ? s.setAttribute('aria-disabled', true) : s.removeAttribute('aria-disabled');
					r == 1 ? s.setAttribute('aria-pressed', true) : s.removeAttribute('aria-pressed');
					return true;
				} else
					return false;
			}
		};
	})();
	p.prototype.addButton = function (r, s) {
		this.add(r, 1, s);
	};
	(function () {
		var r = function (D, E) {
			var F = D.document,
			G = F.getBody(),
			H = false,
			I = function () {
				H = true;
			};
			G.on(E, I);
			(g.version > 7 ? F.$ : F.$.selection.createRange()).execCommand(E);
			G.removeListener(E, I);
			return H;
		},
		s = h ? function (D, E) {
			return r(D, E);
		}
		 : function (D, E) {
			try {
				return D.document.$.execCommand(E, false, null);
			} catch (F) {
				return false;
			}
		},
		t = function (D) {
			var E = this;
			E.type = D;
			E.canUndo = E.type == 'cut';
			E.startDisabled = true;
		};
		t.prototype = {
			exec : function (D, E) {
				this.type == 'cut' && y(D);
				var F = s(D, this.type);
				if (!F)
					alert(D.lang.clipboard[this.type + 'Error']);
				return F;
			}
		};
		var u = {
			canUndo : false,
			exec : h ? function (D) {
				D.focus();
				if (!D.document.getBody().fire('beforepaste') && !r(D, 'paste')) {
					D.fire('pasteDialog');
					return false;
				}
			}
			 : function (D) {
				try {
					if (!D.document.getBody().fire('beforepaste') && !D.document.$.execCommand('Paste', false, null))
						throw 0;
				} catch (E) {
					setTimeout(function () {
						D.fire('pasteDialog');
					}, 0);
					return false;
				}
			}
		},
		v = function (D) {
			if (this.mode != 'wysiwyg')
				return;
			switch (D.data.keyCode) {
			case 1000 + 86:
			case 2000 + 45:
				var E = this.document.getBody();
				if (g.opera || g.gecko)
					E.fire('paste');
				return;
			case 1000 + 88:
			case 2000 + 46:
				var F = this;
				this.fire('saveSnapshot');
				setTimeout(function () {
					F.fire('saveSnapshot');
				}, 0);
			}
		};
		function w(D) {
			D.cancel();
		};
		function x(D, E, F) {
			var G = this.document;
			if (G.getById('cke_pastebin'))
				return;
			if (E == 'text' && D.data && D.data.$.clipboardData) {
				var H = D.data.$.clipboardData.getData('text/plain');
				if (H) {
					D.data.preventDefault();
					F(H);
					return;
				}
			}
			var I = this.getSelection(),
			J = new i.range(G),
			K = new m(E == 'text' ? 'textarea' : g.webkit ? 'body' : 'div', G);
			K.setAttribute('id', 'cke_pastebin');
			g.webkit && K.append(G.createText('\xa0'));
			G.getBody().append(K);
			K.setStyles({
				position : 'absolute',
				top : I.getStartElement().getDocumentPosition().y + 'px',
				width : '1px',
				height : '1px',
				overflow : 'hidden'
			});
			K.setStyle(this.config.contentsLangDirection == 'ltr' ? 'left' : 'right', '-1000px');
			var L = I.createBookmarks();
			this.on('selectionChange', w, null, null, 0);
			if (E == 'text')
				K.$.focus();
			else {
				J.setStartAt(K, 1);
				J.setEndAt(K, 2);
				J.select(true);
			}
			var M = this;
			window.setTimeout(function () {
				M.document.getBody().focus();
				M.removeListener('selectionChange', w);
				if (g.ie7Compat) {
					I.selectBookmarks(L);
					K.remove();
				} else {
					K.remove();
					I.selectBookmarks(L);
				}
				var N;
				K = g.webkit && (N = K.getFirst()) && N.is && N.hasClass('Apple-style-span') ? N : K;
				F(K['get' + (E == 'text' ? 'Value' : 'Html')]());
			}, 0);
		};
		function y(D) {
			if (!h || g.quirks)
				return;
			var E = D.getSelection(),
			F;
			if (E.getType() == 3 && (F = E.getSelectedElement())) {
				var G = E.getRanges()[0],
				H = D.document.createText('');
				H.insertBefore(F);
				G.setStartBefore(H);
				G.setEndAfter(F);
				E.selectRanges([G]);
				setTimeout(function () {
					if (F.getParent()) {
						H.remove();
						E.selectElement(F);
					}
				}, 0);
			}
		};
		var z,
		A;
		function B(D, E) {
			var F;
			if (A && D in {
				Paste : 1,
				Cut : 1
			})
				return 0;
			if (D == 'Paste') {
				h && (z = 1);
				try {
					F = E.document.$.queryCommandEnabled(D) || g.webkit;
				} catch (I) {}
				
				z = 0;
			} else {
				var G = E.getSelection(),
				H = G && G.getRanges();
				F = G && !(H.length == 1 && H[0].collapsed);
			}
			return F ? 2 : 0;
		};
		function C() {
			var E = this;
			if (E.mode != 'wysiwyg')
				return;
			var D = B('Paste', E);
			E.getCommand('cut').setState(B('Cut', E));
			E.getCommand('copy').setState(B('Copy', E));
			E.getCommand('paste').setState(D);
			E.fire('pasteState', D);
		};
		o.add('clipboard', {
			requires : ['dialog', 'htmldataprocessor'],
			init : function (D) {
				D.on('paste', function (F) {
					var G = F.data;
					if (G.html)
						D.insertHtml(G.html);
					else if (G.text)
						D.insertText(G.text);
					setTimeout(function () {
						D.fire('afterPaste');
					}, 0);
				}, null, null, 1000);
				D.on('pasteDialog', function (F) {
					setTimeout(function () {
						D.openDialog('paste');
					}, 0);
				});
				D.on('pasteState', function (F) {
					D.getCommand('paste').setState(F.data);
				});
				function E(F, G, H, I) {
					var J = D.lang[G];
					D.addCommand(G, H);
					D.ui.addButton(F, {
						label : J,
						command : G
					});
					if (D.addMenuItems)
						D.addMenuItem(G, {
							label : J,
							command : G,
							group : 'clipboard',
							order : I
						});
				};
				E('Cut', 'cut', new t('cut'), 1);
				E('Copy', 'copy', new t('copy'), 4);
				E('Paste', 'paste', u, 8);
				f.dialog.add('paste', f.getUrl(this.path + 'dialogs/paste.js'));
				D.on('key', v, D);
				D.on('contentDom', function () {
					var F = D.document.getBody();
					F.on(!h ? 'paste' : 'beforepaste', function (G) {
						if (z)
							return;
						var H = G.data && G.data.$;
						if (h && H && !H.ctrlKey)
							return;
						var I = {
							mode : 'html'
						};
						D.fire('beforePaste', I);
						x.call(D, G, I.mode, function (J) {
							if (!(J = j.trim(J.replace(/<span[^>]+data-cke-bookmark[^<]*?<\/span>/ig, ''))))
								return;
							var K = {};
							K[I.mode] = J;
							D.fire('paste', K);
						});
					});
					if (h) {
						F.on('contextmenu', function () {
							z = 1;
							setTimeout(function () {
								z = 0;
							}, 0);
						});
						F.on('paste', function (G) {
							if (!D.document.getById('cke_pastebin')) {
								G.data.preventDefault();
								z = 0;
								u.exec(D);
							}
						});
					}
					F.on('beforecut', function () {
						!z && y(D);
					});
					F.on('mouseup', function () {
						setTimeout(function () {
							C.call(D);
						}, 0);
					}, D);
					F.on('keyup', C, D);
				});
				D.on('selectionChange', function (F) {
					A = F.data.selection.getRanges()[0].checkReadOnly();
					C.call(D);
				});
				if (D.contextMenu)
					D.contextMenu.addListener(function (F, G) {
						var H = G.getRanges()[0].checkReadOnly();
						return {
							cut : B('Cut', D),
							copy : B('Copy', D),
							paste : B('Paste', D)
						};
					});
			}
		});
	})();
	o.add('colorbutton', {
		requires : ['panelbutton', 'floatpanel', 'styles'],
		init : function (r) {
			var s = r.config,
			t = r.lang.colorButton,
			u;
			if (!g.hc) {
				v('TextColor', 'fore', t.textColorTitle);
				v('BGColor', 'back', t.bgColorTitle);
			}
			function v(y, z, A) {
				var B = j.getNextId() + '_colorBox';
				r.ui.add(y, 4, {
					label : A,
					title : A,
					className : 'cke_button_' + y.toLowerCase(),
					modes : {
						wysiwyg : 1
					},
					panel : {
						css : r.skin.editor.css,
						attributes : {
							role : 'listbox',
							'aria-label' : t.panelTitle
						}
					},
					onBlock : function (C, D) {
						D.autoSize = true;
						D.element.addClass('cke_colorblock');
						D.element.setHtml(w(C, z, B));
						D.element.getDocument().getBody().setStyle('overflow', 'hidden');
						p.fire('ready', this);
						var E = D.keys,
						F = r.lang.dir == 'rtl';
						E[F ? 37 : 39] = 'next';
						E[40] = 'next';
						E[9] = 'next';
						E[F ? 39 : 37] = 'prev';
						E[38] = 'prev';
						E[2000 + 9] = 'prev';
						E[32] = 'click';
					},
					onOpen : function () {
						var C = r.getSelection(),
						D = C && C.getStartElement(),
						E = new i.elementPath(D),
						F;
						D = E.block || E.blockLimit || r.document.getBody();
						do
							F = D && D.getComputedStyle(z == 'back' ? 'background-color' : 'color') || 'transparent';
						while (z == 'back' && F == 'transparent' && D && (D = D.getParent()))
						if (!F || F == 'transparent')
							F = '#ffffff';
						this._.panel._.iframe.getFrameDocument().getById(B).setStyle('background-color', F);
					}
				});
			};
			function w(y, z, A) {
				var B = [],
				C = s.colorButton_colors.split(','),
				D = j.addFunction(function (J, K) {
						if (J == '?') {
							var L = arguments.callee;
							function M(O) {
								this.removeListener('ok', M);
								this.removeListener('cancel', M);
								O.name == 'ok' && L(this.getContentElement('picker', 'selectedColor').getValue(), K);
							};
							r.openDialog('colordialog', function () {
								this.on('ok', M);
								this.on('cancel', M);
							});
							return;
						}
						r.focus();
						y.hide(false);
						r.fire('saveSnapshot');
						new f.style(s['colorButton_' + K + 'Style'], {
							color : 'inherit'
						}).remove(r.document);
						if (J) {
							var N = s['colorButton_' + K + 'Style'];
							N.childRule = K == 'back' ? function (O) {
								return x(O);
							}
							 : function (O) {
								return !(O.is('a') || O.getElementsByTag('a').count()) || x(O);
							};
							new f.style(N, {
								color : J
							}).apply(r.document);
						}
						r.fire('saveSnapshot');
					});
				B.push('<a class="cke_colorauto" _cke_focus=1 hidefocus=true title="', t.auto, '" onclick="CKEDITOR.tools.callFunction(', D, ",null,'", z, "');return false;\" href=\"javascript:void('", t.auto, '\')" role="option"><table role="presentation" cellspacing=0 cellpadding=0 width="100%"><tr><td><span class="cke_colorbox" id="', A, '"></span></td><td colspan=7 align=center>', t.auto, '</td></tr></table></a><table role="presentation" cellspacing=0 cellpadding=0 width="100%">');
				for (var E = 0; E < C.length; E++) {
					if (E % 8 === 0)
						B.push('</tr><tr>');
					var F = C[E].split('/'),
					G = F[0],
					H = F[1] || G;
					if (!F[1])
						G = '#' + G.replace(/^(.)(.)(.)$/, '$1$1$2$2$3$3');
					var I = r.lang.colors[H] || H;
					B.push('<td><a class="cke_colorbox" _cke_focus=1 hidefocus=true title="', I, '" onclick="CKEDITOR.tools.callFunction(', D, ",'", G, "','", z, "'); return false;\" href=\"javascript:void('", I, '\')" role="option"><span class="cke_colorbox" style="background-color:#', H, '"></span></a></td>');
				}
				if (s.colorButton_enableMore === undefined || s.colorButton_enableMore)
					B.push('</tr><tr><td colspan=8 align=center><a class="cke_colormore" _cke_focus=1 hidefocus=true title="', t.more, '" onclick="CKEDITOR.tools.callFunction(', D, ",'?','", z, "');return false;\" href=\"javascript:void('", t.more, "')\"", ' role="option">', t.more, '</a></td>');
				B.push('</tr></table>');
				return B.join('');
			};
			function x(y) {
				return y.getAttribute('contentEditable') == 'false' || y.getAttribute('data-nostyle');
			};
		}
	});
	n.colorButton_colors = '000,800000,8B4513,2F4F4F,008080,000080,4B0082,696969,B22222,A52A2A,DAA520,006400,40E0D0,0000CD,800080,808080,F00,FF8C00,FFD700,008000,0FF,00F,EE82EE,A9A9A9,FFA07A,FFA500,FFFF00,00FF00,AFEEEE,ADD8E6,DDA0DD,D3D3D3,FFF0F5,FAEBD7,FFFFE0,F0FFF0,F0FFFF,F0F8FF,E6E6FA,FFF';
	n.colorButton_foreStyle = {
		element : 'span',
		styles : {
			color : '#(color)'
		},
		overrides : [{
				element : 'font',
				attributes : {
					color : null
				}
			}
		]
	};
	n.colorButton_backStyle = {
		element : 'span',
		styles : {
			'background-color' : '#(color)'
		}
	};
	o.colordialog = {
		requires : ['dialog'],
		init : function (r) {
			r.addCommand('colordialog', new f.dialogCommand('colordialog'));
			f.dialog.add('colordialog', this.path + 'dialogs/colordialog.js');
		}
	};
	o.add('colordialog', o.colordialog);
	o.add('contextmenu', {
		requires : ['menu'],
		onLoad : function () {
			o.contextMenu = j.createClass({
					base : f.menu,
					$ : function (r) {
						this.base.call(this, r, {
							panel : {
								className : r.skinClass + ' cke_contextmenu',
								attributes : {
									'aria-label' : r.lang.contextmenu.options
								}
							}
						});
					},
					proto : {
						addTarget : function (r, s) {
							if (g.opera && !('oncontextmenu' in document.body)) {
								var t;
								r.on('mousedown', function (x) {
									x = x.data;
									if (x.$.button != 2) {
										if (x.getKeystroke() == 1000 + 1)
											r.fire('contextmenu', x);
										return;
									}
									if (s && (g.mac ? x.$.metaKey : x.$.ctrlKey))
										return;
									var y = x.getTarget();
									if (!t) {
										var z = y.getDocument();
										t = z.createElement('input');
										t.$.type = 'button';
										z.getBody().append(t);
									}
									t.setAttribute('style', 'position:absolute;top:' + (x.$.clientY - 2) + 'px;left:' + (x.$.clientX - 2) + 'px;width:5px;height:5px;opacity:0.01');
								});
								r.on('mouseup', function (x) {
									if (t) {
										t.remove();
										t = undefined;
										r.fire('contextmenu', x.data);
									}
								});
							}
							r.on('contextmenu', function (x) {
								var y = x.data;
								if (s && (g.webkit ? u : g.mac ? y.$.metaKey : y.$.ctrlKey))
									return;
								y.preventDefault();
								var z = y.getTarget().getDocument().getDocumentElement(),
								A = y.$.clientX,
								B = y.$.clientY;
								j.setTimeout(function () {
									this.open(z, null, A, B);
								}, h ? 200 : 0, this);
							}, this);
							if (g.opera)
								r.on('keypress', function (x) {
									var y = x.data;
									if (y.$.keyCode === 0)
										y.preventDefault();
								});
							if (g.webkit) {
								var u,
								v = function (x) {
									u = g.mac ? x.data.$.metaKey : x.data.$.ctrlKey;
								},
								w = function () {
									u = 0;
								};
								r.on('keydown', v);
								r.on('keyup', w);
								r.on('contextmenu', w);
							}
						},
						open : function (r, s, t, u) {
							this.editor.focus();
							r = r || f.document.getDocumentElement();
							this.show(r, s, t, u);
						}
					}
				});
		},
		beforeInit : function (r) {
			r.contextMenu = new o.contextMenu(r);
			r.addCommand('contextMenu', {
				exec : function () {
					r.contextMenu.open(r.document.getBody());
				}
			});
		}
	});
	(function () {
		function r(t) {
			var u = this.att,
			v = t && t.hasAttribute(u) && t.getAttribute(u) || '';
			if (v !== undefined)
				this.setValue(v);
		};
		function s() {
			var t;
			for (var u = 0; u < arguments.length; u++) {
				if (arguments[u]instanceof m) {
					t = arguments[u];
					break;
				}
			}
			if (t) {
				var v = this.att,
				w = this.getValue();
				if (w)
					t.setAttribute(v, w);
				else
					t.removeAttribute(v, w);
			}
		};
		o.add('dialogadvtab', {
			createAdvancedTab : function (t, u) {
				if (!u)
					u = {
						id : 1,
						dir : 1,
						classes : 1,
						styles : 1
					};
				var v = t.lang.common,
				w = {
					id : 'advanced',
					label : v.advancedTab,
					title : v.advancedTab,
					elements : [{
							type : 'vbox',
							padding : 1,
							children : []
						}
					]
				},
				x = [];
				if (u.id || u.dir) {
					if (u.id)
						x.push({
							id : 'advId',
							att : 'id',
							type : 'text',
							label : v.id,
							setup : r,
							commit : s
						});
					if (u.dir)
						x.push({
							id : 'advLangDir',
							att : 'dir',
							type : 'select',
							label : v.langDir,
							'default' : '',
							style : 'width:100%',
							items : [[v.notSet, ''], [v.langDirLTR, 'ltr'], [v.langDirRTL, 'rtl']],
							setup : r,
							commit : s
						});
					w.elements[0].children.push({
						type : 'hbox',
						widths : ['50%', '50%'],
						children : [].concat(x)
					});
				}
				if (u.styles || u.classes) {
					x = [];
					if (u.styles)
						x.push({
							id : 'advStyles',
							att : 'style',
							type : 'text',
							label : v.styles,
							'default' : '',
							validate : f.dialog.validate.inlineStyle(v.invalidInlineStyle),
							onChange : function () {},
							getStyle : function (y, z) {
								var A = this.getValue().match(new RegExp('(?:^|;)\\s*' + y + '\\s*:\\s*([^;]*)', 'i'));
								return A ? A[1] : z;
							},
							updateStyle : function (y, z) {
								var A = this.getValue(),
								B = t.document.createElement('span');
								B.setAttribute('style', A);
								B.setStyle(y, z);
								A = j.normalizeCssText(B.getAttribute('style'));
								this.setValue(A, 1);
							},
							setup : r,
							commit : s
						});
					if (u.classes)
						x.push({
							type : 'hbox',
							widths : ['45%', '55%'],
							children : [{
									id : 'advCSSClasses',
									att : 'class',
									type : 'text',
									label : v.cssClasses,
									'default' : '',
									setup : r,
									commit : s
								}
							]
						});
					w.elements[0].children.push({
						type : 'hbox',
						widths : ['50%', '50%'],
						children : [].concat(x)
					});
				}
				return w;
			}
		});
	})();
	(function () {
		o.add('div', {
			requires : ['editingblock', 'dialog', 'domiterator', 'styles'],
			init : function (r) {
				var s = r.lang.div;
				r.addCommand('creatediv', new f.dialogCommand('creatediv'));
				r.addCommand('editdiv', new f.dialogCommand('editdiv'));
				r.addCommand('removediv', {
					exec : function (t) {
						var u = t.getSelection(),
						v = u && u.getRanges(),
						w,
						x = u.createBookmarks(),
						y,
						z = [];
						function A(C) {
							var D = new i.elementPath(C),
							E = D.blockLimit,
							F = E.is('div') && E;
							if (F && !F.data('cke-div-added')) {
								z.push(F);
								F.data('cke-div-added');
							}
						};
						for (var B = 0; B < v.length;
							B++) {
							w = v[B];
							if (w.collapsed)
								A(u.getStartElement());
							else {
								y = new i.walker(w);
								y.evaluator = A;
								y.lastForward();
							}
						}
						for (B = 0; B < z.length; B++)
							z[B].remove(true);
						u.selectBookmarks(x);
					}
				});
				r.ui.addButton('CreateDiv', {
					label : s.toolbar,
					command : 'creatediv'
				});
				if (r.addMenuItems) {
					r.addMenuItems({
						editdiv : {
							label : s.edit,
							command : 'editdiv',
							group : 'div',
							order : 1
						},
						removediv : {
							label : s.remove,
							command : 'removediv',
							group : 'div',
							order : 5
						}
					});
					if (r.contextMenu)
						r.contextMenu.addListener(function (t, u) {
							if (!t || t.isReadOnly())
								return null;
							var v = new i.elementPath(t),
							w = v.blockLimit;
							if (w && w.getAscendant('div', true))
								return {
									editdiv : 2,
									removediv : 2
								};
							return null;
						});
				}
				f.dialog.add('creatediv', this.path + 'dialogs/div.js');
				f.dialog.add('editdiv', this.path + 'dialogs/div.js');
			}
		});
	})();
	(function () {
		var r = {
			toolbarFocus : {
				editorFocus : false,
				readOnly : 1,
				exec : function (t) {
					var u = t._.elementsPath.idBase,
					v = f.document.getById(u + '0');
					v && v.focus(h || g.air);
				}
			}
		},
		s = '<span class="cke_empty">&nbsp;</span>';
		o.add('elementspath', {
			requires : ['selection'],
			init : function (t) {
				var u = 'cke_path_' + t.name,
				v,
				w = function () {
					if (!v)
						v = f.document.getById(u);
					return v;
				},
				x = 'cke_elementspath_' + j.getNextNumber() + '_';
				t._.elementsPath = {
					idBase : x,
					filters : []
				};
				t.on('themeSpace', function (C) {
					if (C.data.space == 'bottom')
						C.data.html += '<span id="' + u + '_label" class="cke_voice_label">' + t.lang.elementsPath.eleLabel + '</span>' + '<div id="' + u + '" class="cke_path" role="group" aria-labelledby="' + u + '_label">' + s + '</div>';
				});
				function y(C) {
					t.focus();
					var D = t._.elementsPath.list[C];
					if (D.is('body')) {
						var E = new i.range(t.document);
						E.selectNodeContents(D);
						E.select();
					} else
						t.getSelection().selectElement(D);
				};
				var z = j.addFunction(y),
				A = j.addFunction(function (C, D) {
						var E = t._.elementsPath.idBase,
						F;
						D = new i.event(D);
						var G = t.lang.dir == 'rtl';
						switch (D.getKeystroke()) {
						case G ? 39:
							37 : case 9:
							F = f.document.getById(E + (C + 1));
							if (!F)
								F = f.document.getById(E + '0');
							F.focus();
							return false;
						case G ? 37:
							39 : case 2000 + 9:
							F = f.document.getById(E + (C - 1));
							if (!F)
								F = f.document.getById(E + (t._.elementsPath.list.length - 1));
							F.focus();
							return false;
						case 27:
							t.focus();
							return false;
						case 13:
						case 32:
							y(C);
							return false;
						}
						return true;
					});
				t.on('selectionChange', function (C) {
					var D = g,
					E = C.data.selection,
					F = E.getStartElement(),
					G = [],
					H = C.editor,
					I = H._.elementsPath.list = [],
					J = H._.elementsPath.filters;
					while (F) {
						var K = 0,
						L;
						if (F.data('cke-display-name'))
							L = F.data('cke-display-name');
						else if (F.data('cke-real-element-type'))
							L = F.data('cke-real-element-type');
						else
							L = F.getName();
						for (var M = 0; M < J.length; M++) {
							var N = J[M](F, L);
							if (N === false) {
								K = 1;
								break;
							}
							L = N || L;
						}
						if (!K) {
							var O = I.push(F) - 1,
							P = '';
							if (D.opera || D.gecko && D.mac)
								P += ' onkeypress="return false;"';
							if (D.gecko)
								P += ' onblur="this.style.cssText = this.style.cssText;"';
							var Q = H.lang.elementsPath.eleTitle.replace(/%1/, L);
							G.unshift('<a id="', x, O, '" href="javascript:void(\'', L, '\')" tabindex="-1" title="', Q, '"' + (g.gecko && g.version < 10900 ? ' onfocus="event.preventBubble();"' : '') + ' hidefocus="true" ' + ' onkeydown="return CKEDITOR.tools.callFunction(', A, ',', O, ', event );"' + P, ' onclick="CKEDITOR.tools.callFunction(' + z, ',', O, '); return false;"', ' role="button" aria-labelledby="' + x + O + '_label">', L, '<span id="', x, O, '_label" class="cke_label">' + Q + '</span>', '</a>');
						}
						if (L == 'body')
							break;
						F = F.getParent();
					}
					var R = w();
					R.setHtml(G.join('') + s);
					H.fire('elementsPathUpdate', {
						space : R
					});
				});
				function B() {
					v && v.setHtml(s);
					delete t._.elementsPath.list;
				};
				t.on('readOnly', B);
				t.on('contentDomUnload', B);
				t.addCommand('elementsPathFocus', r.toolbarFocus);
			}
		});
	})();
	(function () {
		o.add('enterkey', {
			requires : ['keystrokes', 'indent'],
			init : function (y) {
				y.addCommand('enter', {
					modes : {
						wysiwyg : 1
					},
					editorFocus : false,
					exec : function (A) {
						w(A);
					}
				});
				y.addCommand('shiftEnter', {
					modes : {
						wysiwyg : 1
					},
					editorFocus : false,
					exec : function (A) {
						v(A);
					}
				});
				var z = y.keystrokeHandler.keystrokes;
				z[13] = 'enter';
				z[2000 + 13] = 'shiftEnter';
			}
		});
		o.enterkey = {
			enterBlock : function (y, z, A, B) {
				A = A || x(y);
				if (!A)
					return;
				var C = A.document,
				D = A.checkStartOfBlock(),
				E = A.checkEndOfBlock(),
				F = new i.elementPath(A.startContainer),
				G = F.block;
				if (D && E) {
					if (G && (G.is('li') || G.getParent().is('li'))) {
						y.execCommand('outdent');
						return;
					}
					if (G && G.getParent().is('blockquote')) {
						G.breakParent(G.getParent());
						if (!G.getPrevious().getFirst(i.walker.invisible(1)))
							G.getPrevious().remove();
						if (!G.getNext().getFirst(i.walker.invisible(1)))
							G.getNext().remove();
						A.moveToElementEditStart(G);
						A.select();
						return;
					}
				} else if (G && G.is('pre')) {
					if (!E) {
						s(y, z, A, B);
						return;
					}
				} else if (G && k.$captionBlock[G.getName()]) {
					s(y, z, A, B);
					return;
				}
				var H = z == 3 ? 'div' : 'p',
				I = A.splitBlock(H);
				if (!I)
					return;
				var J = I.previousBlock,
				K = I.nextBlock,
				L = I.wasStartOfBlock,
				M = I.wasEndOfBlock,
				N;
				if (K) {
					N = K.getParent();
					if (N.is('li')) {
						K.breakParent(N);
						K.move(K.getNext(), 1);
					}
				} else if (J && (N = J.getParent()) && N.is('li')) {
					J.breakParent(N);
					N = J.getNext();
					A.moveToElementEditStart(N);
					J.move(J.getPrevious());
				}
				if (!L && !M) {
					if (K.is('li') && (N = K.getFirst(i.walker.invisible(true))) && N.is && N.is('ul', 'ol'))
						(h ? C.createText('\xa0') : C.createElement('br')).insertBefore(N);
					if (K)
						A.moveToElementEditStart(K);
				} else {
					var O,
					P;
					if (J) {
						if (J.is('li') || !(u.test(J.getName()) || J.is('pre')))
							O = J.clone();
					} else if (K)
						O = K.clone();
					if (!O) {
						if (N && N.is('li'))
							O = N;
						else {
							O = C.createElement(H);
							if (J && (P = J.getDirection()))
								O.setAttribute('dir', P);
						}
					} else if (B && !O.is('li'))
						O.renameNode(H);
					var Q = I.elementPath;
					if (Q)
						for (var R = 0, S = Q.elements.length; R < S; R++) {
							var T = Q.elements[R];
							if (T.equals(Q.block) || T.equals(Q.blockLimit))
								break;
							if (k.$removeEmpty[T.getName()]) {
								T = T.clone();
								O.moveChildren(T);
								O.append(T);
							}
						}
					if (!h)
						O.appendBogus();
					if (!O.getParent())
						A.insertNode(O);
					O.is('li') && O.removeAttribute('value');
					if (h && L && (!M || !J.getChildCount())) {
						A.moveToElementEditStart(M ? J : O);
						A.select();
					}
					A.moveToElementEditStart(L && !M ? K : O);
				}
				if (!h)
					if (K) {
						var U = C.createElement('span');
						U.setHtml('&nbsp;');
						A.insertNode(U);
						U.scrollIntoView();
						A.deleteContents();
					} else
						O.scrollIntoView();
				A.select();
			},
			enterBr : function (y, z, A, B) {
				A = A || x(y);
				if (!A)
					return;
				var C = A.document,
				D = z == 3 ? 'div' : 'p',
				E = A.checkEndOfBlock(),
				F = new i.elementPath(y.getSelection().getStartElement()),
				G = F.block,
				H = G && F.block.getName(),
				I = false;
				if (!B && H == 'li') {
					t(y, z, A, B);
					return;
				}
				if (!B && E && u.test(H)) {
					var J,
					K;
					if (K = G.getDirection()) {
						J = C.createElement('div');
						J.setAttribute('dir', K);
						J.insertAfter(G);
						A.setStart(J, 0);
					} else {
						C.createElement('br').insertAfter(G);
						if (g.gecko)
							C.createText('').insertAfter(G);
						A.setStartAt(G.getNext(), h ? 3 : 1);
					}
				} else {
					var L;
					I = H == 'pre';
					if (H == 'pre' && h && g.version < 8)
						L = C.createText('\r');
					else
						L = C.createElement('br');
					A.deleteContents();
					A.insertNode(L);
					if (h)
						A.setStartAt(L, 4);
					else {
						C.createText('\ufeff').insertAfter(L);
						if (E)
							L.getParent().appendBogus();
						L.getNext().$.nodeValue = '';
						A.setStartAt(L.getNext(), 1);
						var M = null;
						if (!g.gecko) {
							M = C.createElement('span');
							M.setHtml('&nbsp;');
						} else
							M = C.createElement('br');
						M.insertBefore(L.getNext());
						M.scrollIntoView();
						M.remove();
					}
				}
				A.collapse(true);
				A.select(I);
			}
		};
		var r = o.enterkey,
		s = r.enterBr,
		t = r.enterBlock,
		u = /^h[1-6]$/;
		function v(y) {
			if (y.mode != 'wysiwyg')
				return false;
			return w(y, y.config.shiftEnterMode, 1);
		};
		function w(y, z, A) {
			A = y.config.forceEnterMode || A;
			if (y.mode != 'wysiwyg')
				return false;
			if (!z)
				z = y.config.enterMode;
			setTimeout(function () {
				y.fire('saveSnapshot');
				if (z == 2)
					s(y, z, null, A);
				else
					t(y, z, null, A);
				y.fire('saveSnapshot');
			}, 0);
			return true;
		};
		function x(y) {
			var z = y.getSelection().getRanges(true);
			for (var A = z.length - 1; A > 0; A--)
				z[A].deleteContents();
			return z[0];
		};
	})();
	(function () {
		var r = 'nbsp,gt,lt,amp',
		s = 'quot,iexcl,cent,pound,curren,yen,brvbar,sect,uml,copy,ordf,laquo,not,shy,reg,macr,deg,plusmn,sup2,sup3,acute,micro,para,middot,cedil,sup1,ordm,raquo,frac14,frac12,frac34,iquest,times,divide,fnof,bull,hellip,prime,Prime,oline,frasl,weierp,image,real,trade,alefsym,larr,uarr,rarr,darr,harr,crarr,lArr,uArr,rArr,dArr,hArr,forall,part,exist,empty,nabla,isin,notin,ni,prod,sum,minus,lowast,radic,prop,infin,ang,and,or,cap,cup,int,there4,sim,cong,asymp,ne,equiv,le,ge,sub,sup,nsub,sube,supe,oplus,otimes,perp,sdot,lceil,rceil,lfloor,rfloor,lang,rang,loz,spades,clubs,hearts,diams,circ,tilde,ensp,emsp,thinsp,zwnj,zwj,lrm,rlm,ndash,mdash,lsquo,rsquo,sbquo,ldquo,rdquo,bdquo,dagger,Dagger,permil,lsaquo,rsaquo,euro',
		t = 'Agrave,Aacute,Acirc,Atilde,Auml,Aring,AElig,Ccedil,Egrave,Eacute,Ecirc,Euml,Igrave,Iacute,Icirc,Iuml,ETH,Ntilde,Ograve,Oacute,Ocirc,Otilde,Ouml,Oslash,Ugrave,Uacute,Ucirc,Uuml,Yacute,THORN,szlig,agrave,aacute,acirc,atilde,auml,aring,aelig,ccedil,egrave,eacute,ecirc,euml,igrave,iacute,icirc,iuml,eth,ntilde,ograve,oacute,ocirc,otilde,ouml,oslash,ugrave,uacute,ucirc,uuml,yacute,thorn,yuml,OElig,oelig,Scaron,scaron,Yuml',
		u = 'Alpha,Beta,Gamma,Delta,Epsilon,Zeta,Eta,Theta,Iota,Kappa,Lambda,Mu,Nu,Xi,Omicron,Pi,Rho,Sigma,Tau,Upsilon,Phi,Chi,Psi,Omega,alpha,beta,gamma,delta,epsilon,zeta,eta,theta,iota,kappa,lambda,mu,nu,xi,omicron,pi,rho,sigmaf,sigma,tau,upsilon,phi,chi,psi,omega,thetasym,upsih,piv';
		function v(w, x) {
			var y = {},
			z = [],
			A = {
				nbsp : '\xa0',
				shy : '­',
				gt : '>',
				lt : '<',
				amp : '&',
				apos : "'",
				quot : '"'
			};
			w = w.replace(/\b(nbsp|shy|gt|lt|amp|apos|quot)(?:,|$)/g, function (F, G) {
					var H = x ? '&' + G + ';' : A[G],
					I = x ? A[G] : '&' + G + ';';
					y[H] = I;
					z.push(H);
					return '';
				});
			if (!x && w) {
				w = w.split(',');
				var B = document.createElement('div'),
				C;
				B.innerHTML = '&' + w.join(';&') + ';';
				C = B.innerHTML;
				B = null;
				for (var D = 0; D < C.length; D++) {
					var E = C.charAt(D);
					y[E] = '&' + w[D] + ';';
					z.push(E);
				}
			}
			y.regex = z.join(x ? '|' : '');
			return y;
		};
		o.add('entities', {
			afterInit : function (w) {
				var x = w.config,
				y = w.dataProcessor,
				z = y && y.htmlFilter;
				if (z) {
					var A = [];
					if (x.basicEntities !== false)
						A.push(r);
					if (x.entities) {
						if (A.length)
							A.push(s);
						if (x.entities_latin)
							A.push(t);
						if (x.entities_greek)
							A.push(u);
						if (x.entities_additional)
							A.push(x.entities_additional);
					}
					var B = v(A.join(',')),
					C = B.regex ? '[' + B.regex + ']' : 'a^';
					delete B.regex;
					if (x.entities && x.entities_processNumerical)
						C = '[^ -~]|' + C;
					C = new RegExp(C, 'g');
					function D(H) {
						return x.entities_processNumerical == 'force' || !B[H] ? '&#' + H.charCodeAt(0) + ';' : B[H];
					};
					var E = v([r, 'shy'].join(','), true),
					F = new RegExp(E.regex, 'g');
					function G(H) {
						return E[H];
					};
					z.addRules({
						text : function (H) {
							return H.replace(F, G).replace(C, D);
						}
					});
				}
			}
		});
	})();
	n.basicEntities = true;
	n.entities = true;
	n.entities_latin = true;
	n.entities_greek = true;
	n.entities_additional = '#39';
	o.add('find', {
		requires : ['dialog'],
		init : function (r) {
			var s = o.find;
			r.ui.addButton('Find', {
				label : r.lang.findAndReplace.find,
				command : 'find'
			});
			var t = r.addCommand('find', new f.dialogCommand('find'));
			t.canUndo = false;
			t.readOnly = 1;
			r.ui.addButton('Replace', {
				label : r.lang.findAndReplace.replace,
				command : 'replace'
			});
			var u = r.addCommand('replace', new f.dialogCommand('replace'));
			u.canUndo = false;
			f.dialog.add('find', this.path + 'dialogs/find.js');
			f.dialog.add('replace', this.path + 'dialogs/find.js');
		},
		requires : ['styles']
	});
	n.find_highlight = {
		element : 'span',
		styles : {
			'background-color' : '#004',
			color : '#fff'
		}
	};
	(function () {
		function r(s, t, u, v, w, x, y) {
			var z = s.config,
			A = w.split(';'),
			B = [],
			C = {};
			for (var D = 0; D < A.length; D++) {
				var E = A[D];
				if (E) {
					E = E.split('/');
					var F = {},
					G = A[D] = E[0];
					F[u] = B[D] = E[1] || G;
					C[G] = new f.style(y, F);
					C[G]._.definition.name = G;
				} else
					A.splice(D--, 1);
			}
			s.ui.addRichCombo(t, {
				label : v.label,
				title : v.panelTitle,
				className : 'cke_' + (u == 'size' ? 'fontSize' : 'font'),
				panel : {
					css : s.skin.editor.css.concat(z.contentsCss),
					multiSelect : false,
					attributes : {
						'aria-label' : v.panelTitle
					}
				},
				init : function () {
					this.startGroup(v.panelTitle);
					for (var H = 0; H < A.length; H++) {
						var I = A[H];
						this.add(I, C[I].buildPreview(), I);
					}
				},
				onClick : function (H) {
					s.focus();
					s.fire('saveSnapshot');
					var I = C[H];
					if (this.getValue() == H)
						I.remove(s.document);
					else
						I.apply(s.document);
					s.fire('saveSnapshot');
				},
				onRender : function () {
					s.on('selectionChange', function (H) {
						var I = this.getValue(),
						J = H.data.path,
						K = J.elements;
						for (var L = 0, M; L < K.length; L++) {
							M = K[L];
							for (var N in C) {
								if (C[N].checkElementMatch(M, true)) {
									if (N != I)
										this.setValue(N);
									return;
								}
							}
						}
						this.setValue('', x);
					}, this);
				}
			});
		};
		o.add('font', {
			requires : ['richcombo', 'styles'],
			init : function (s) {
				var t = s.config;
				r(s, 'Font', 'family', s.lang.font, t.font_names, t.font_defaultLabel, t.font_style);
				r(s, 'FontSize', 'size', s.lang.fontSize, t.fontSize_sizes, t.fontSize_defaultLabel, t.fontSize_style);
			}
		});
	})();
	n.font_names = 'Arial/Arial, Helvetica, sans-serif;Comic Sans MS/Comic Sans MS, cursive;Courier New/Courier New, Courier, monospace;Georgia/Georgia, serif;Lucida Sans Unicode/Lucida Sans Unicode, Lucida Grande, sans-serif;Tahoma/Tahoma, Geneva, sans-serif;Times New Roman/Times New Roman, Times, serif;Trebuchet MS/Trebuchet MS, Helvetica, sans-serif;Verdana/Verdana, Geneva, sans-serif';
	n.font_defaultLabel = '';
	n.font_style = {
		element : 'span',
		styles : {
			'font-family' : '#(family)'
		},
		overrides : [{
				element : 'font',
				attributes : {
					face : null
				}
			}
		]
	};
	n.fontSize_sizes = '8/8px;9/9px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;22/22px;24/24px;26/26px;28/28px;36/36px;48/48px;72/72px';
	n.fontSize_defaultLabel = '';
	n.fontSize_style = {
		element : 'span',
		styles : {
			'font-size' : '#(size)'
		},
		overrides : [{
				element : 'font',
				attributes : {
					size : null
				}
			}
		]
	};
	o.add('format', {
		requires : ['richcombo', 'styles'],
		init : function (r) {
			var s = r.config,
			t = r.lang.format,
			u = s.format_tags.split(';'),
			v = {};
			for (var w = 0; w < u.length; w++) {
				var x = u[w];
				v[x] = new f.style(s['format_' + x]);
				v[x]._.enterMode = r.config.enterMode;
			}
			r.ui.addRichCombo('Format', {
				label : t.label,
				title : t.panelTitle,
				className : 'cke_format',
				panel : {
					css : r.skin.editor.css.concat(s.contentsCss),
					multiSelect : false,
					attributes : {
						'aria-label' : t.panelTitle
					}
				},
				init : function () {
					this.startGroup(t.panelTitle);
					for (var y in v) {
						var z = t['tag_' + y];
						this.add(y, v[y].buildPreview(z), z);
					}
				},
				onClick : function (y) {
					r.focus();
					r.fire('saveSnapshot');
					var z = v[y],
					A = new i.elementPath(r.getSelection().getStartElement());
					z[z.checkActive(A) ? 'remove' : 'apply'](r.document);
					setTimeout(function () {
						r.fire('saveSnapshot');
					}, 0);
				},
				onRender : function () {
					r.on('selectionChange', function (y) {
						var z = this.getValue(),
						A = y.data.path;
						for (var B in v) {
							if (v[B].checkActive(A)) {
								if (B != z)
									this.setValue(B, r.lang.format['tag_' + B]);
								return;
							}
						}
						this.setValue('');
					}, this);
				}
			});
		}
	});
	n.format_tags = 'p;h1;h2;h3;h4;h5;h6;pre;address;div';
	n.format_p = {
		element : 'p'
	};
	n.format_div = {
		element : 'div'
	};
	n.format_pre = {
		element : 'pre'
	};
	n.format_address = {
		element : 'address'
	};
	n.format_h1 = {
		element : 'h1'
	};
	n.format_h2 = {
		element : 'h2'
	};
	n.format_h3 = {
		element : 'h3'
	};
	n.format_h4 = {
		element : 'h4'
	};
	n.format_h5 = {
		element : 'h5'
	};
	n.format_h6 = {
		element : 'h6'
	};
	o.add('forms', {
		requires : ['dialog'],
		init : function (r) {
			var s = r.lang;
			r.addCss('form{border: 1px dotted #FF0000;padding: 2px;}\n');
			r.addCss('img.cke_hidden{background-image: url(' + f.getUrl(this.path + 'images/hiddenfield.gif') + ');' + 'background-position: center center;' + 'background-repeat: no-repeat;' + 'border: 1px solid #a9a9a9;' + 'width: 16px !important;' + 'height: 16px !important;' + '}');
			var t = function (v, w, x) {
				r.addCommand(w, new f.dialogCommand(w));
				r.ui.addButton(v, {
					label : s.common[v.charAt(0).toLowerCase() + v.slice(1)],
					command : w
				});
				f.dialog.add(w, x);
			},
			u = this.path + 'dialogs/';
			t('Form', 'form', u + 'form.js');
			t('Checkbox', 'checkbox', u + 'checkbox.js');
			t('Radio', 'radio', u + 'radio.js');
			t('TextField', 'textfield', u + 'textfield.js');
			t('Textarea', 'textarea', u + 'textarea.js');
			t('Select', 'select', u + 'select.js');
			t('Button', 'button', u + 'button.js');
			t('ImageButton', 'imagebutton', o.getPath('image') + 'dialogs/image.js');
			t('HiddenField', 'hiddenfield', u + 'hiddenfield.js');
			if (r.addMenuItems)
				r.addMenuItems({
					form : {
						label : s.form.menu,
						command : 'form',
						group : 'form'
					},
					checkbox : {
						label : s.checkboxAndRadio.checkboxTitle,
						command : 'checkbox',
						group : 'checkbox'
					},
					radio : {
						label : s.checkboxAndRadio.radioTitle,
						command : 'radio',
						group : 'radio'
					},
					textfield : {
						label : s.textfield.title,
						command : 'textfield',
						group : 'textfield'
					},
					hiddenfield : {
						label : s.hidden.title,
						command : 'hiddenfield',
						group : 'hiddenfield'
					},
					imagebutton : {
						label : s.image.titleButton,
						command : 'imagebutton',
						group : 'imagebutton'
					},
					button : {
						label : s.button.title,
						command : 'button',
						group : 'button'
					},
					select : {
						label : s.select.title,
						command : 'select',
						group : 'select'
					},
					textarea : {
						label : s.textarea.title,
						command : 'textarea',
						group : 'textarea'
					}
				});
			if (r.contextMenu) {
				r.contextMenu.addListener(function (v) {
					if (v && v.hasAscendant('form', true) && !v.isReadOnly())
						return {
							form : 2
						};
				});
				r.contextMenu.addListener(function (v) {
					if (v && !v.isReadOnly()) {
						var w = v.getName();
						if (w == 'select')
							return {
								select : 2
							};
						if (w == 'textarea')
							return {
								textarea : 2
							};
						if (w == 'input')
							switch (v.getAttribute('type')) {
							case 'button':
							case 'submit':
							case 'reset':
								return {
									button : 2
								};
							case 'checkbox':
								return {
									checkbox : 2
								};
							case 'radio':
								return {
									radio : 2
								};
							case 'image':
								return {
									imagebutton : 2
								};
							default:
								return {
									textfield : 2
								};
							}
						if (w == 'img' && v.data('cke-real-element-type') == 'hiddenfield')
							return {
								hiddenfield : 2
							};
					}
				});
			}
			r.on('doubleclick', function (v) {
				var w = v.data.element;
				if (w.is('form'))
					v.data.dialog = 'form';
				else if (w.is('select'))
					v.data.dialog = 'select';
				else if (w.is('textarea'))
					v.data.dialog = 'textarea';
				else if (w.is('img') && w.data('cke-real-element-type') == 'hiddenfield')
					v.data.dialog = 'hiddenfield';
				else if (w.is('input'))
					switch (w.getAttribute('type')) {
					case 'button':
					case 'submit':
					case 'reset':
						v.data.dialog = 'button';
						break;
					case 'checkbox':
						v.data.dialog = 'checkbox';
						break;
					case 'radio':
						v.data.dialog = 'radio';
						break;
					case 'image':
						v.data.dialog = 'imagebutton';
						break;
					default:
						v.data.dialog = 'textfield';
						break;
					}
			});
		},
		afterInit : function (r) {
			var s = r.dataProcessor,
			t = s && s.htmlFilter,
			u = s && s.dataFilter;
			if (h)
				t && t.addRules({
					elements : {
						input : function (v) {
							var w = v.attributes,
							x = w.type;
							if (!x)
								w.type = 'text';
							if (x == 'checkbox' || x == 'radio')
								w.value == 'on' && delete w.value;
						}
					}
				});
			if (u)
				u.addRules({
					elements : {
						input : function (v) {
							if (v.attributes.type == 'hidden')
								return r.createFakeParserElement(v, 'cke_hidden', 'hiddenfield');
						}
					}
				});
		},
		requires : ['image', 'fakeobjects']
	});
	if (h)
		m.prototype.hasAttribute = j.override(m.prototype.hasAttribute, function (r) {
				return function (s) {
					var v = this;
					var t = v.$.attributes.getNamedItem(s);
					if (v.getName() == 'input')
						switch (s) {
						case 'class':
							return v.$.className.length > 0;
						case 'checked':
							return !!v.$.checked;
						case 'value':
							var u = v.getAttribute('type');
							return u == 'checkbox' || u == 'radio' ? v.$.value != 'on' : v.$.value;
						}
					return r.apply(v, arguments);
				};
			});
	(function () {
		var r = {
			canUndo : false,
			exec : function (t) {
				var u = t.document.createElement('hr');
				t.insertElement(u);
			}
		},
		s = 'horizontalrule';
		o.add(s, {
			init : function (t) {
				t.addCommand(s, r);
				t.ui.addButton('HorizontalRule', {
					label : t.lang.horizontalrule,
					command : s
				});
			}
		});
	})();
	(function () {
		var r = /^[\t\r\n ]*(?:&nbsp;|\xa0)$/,
		s = '{cke_protected}';
		function t(Z) {
			var aa = Z.children.length,
			ab = Z.children[aa - 1];
			while (ab && ab.type == 3 && !j.trim(ab.value))
				ab = Z.children[--aa];
			return ab;
		};
		function u(Z) {
			var aa = Z.parent;
			return aa ? j.indexOf(aa.children, Z) : -1;
		};
		function v(Z, aa) {
			var ab = Z.children,
			ac = t(Z);
			if (ac) {
				if ((aa || !h) && ac.type == 1 && ac.name == 'br')
					ab.pop();
				if (ac.type == 3 && r.test(ac.value))
					ab.pop();
			}
		};
		function w(Z, aa, ab) {
			if (!aa && (!ab || typeof ab == 'function' && ab(Z) === false))
				return false;
			if (aa && h && (document.documentMode > 7 || Z.name in k.tr || Z.name in k.$listItem))
				return false;
			var ac = t(Z);
			return !ac || ac && (ac.type == 1 && ac.name == 'br' || Z.name == 'form' && ac.name == 'input');
		};
		function x(Z, aa) {
			return function (ab) {
				v(ab, !Z);
				if (w(ab, !Z, aa))
					if (Z || h)
						ab.add(new f.htmlParser.text('\xa0'));
					else
						ab.add(new f.htmlParser.element('br', {}));
			};
		};
		var y = k,
		z = ['caption', 'colgroup', 'col', 'thead', 'tfoot', 'tbody'],
		A = j.extend({}, y.$block, y.$listItem, y.$tableContent);
		for (var B in A) {
			if (!('br' in y[B]))
				delete A[B];
		}
		delete A.pre;
		var C = {
			elements : {},
			attributeNames : [[/^on/, 'data-cke-pa-on']]
		},
		D = {
			elements : {}
			
		};
		for (B in A)
			D.elements[B] = x();
		var E = {
			elementNames : [[/^cke:/, ''], [/^\?xml:namespace$/, '']],
			attributeNames : [[/^data-cke-(saved|pa)-/, ''], [/^data-cke-.*/, ''], ['hidefocus', '']],
			elements : {
				$ : function (Z) {
					var aa = Z.attributes;
					if (aa) {
						if (aa['data-cke-temp'])
							return false;
						var ab = ['name', 'href', 'src'],
						ac;
						for (var ad = 0; ad < ab.length; ad++) {
							ac = 'data-cke-saved-' + ab[ad];
							ac in aa && delete aa[ab[ad]];
						}
					}
					return Z;
				},
				table : function (Z) {
					var aa = Z.children.slice(0);
					aa.sort(function (ab, ac) {
						var ad,
						ae;
						if (ab.type == 1 && ac.type == ab.type) {
							ad = j.indexOf(z, ab.name);
							ae = j.indexOf(z, ac.name);
						}
						if (!(ad > -1 && ae > -1 && ad != ae)) {
							ad = u(ab);
							ae = u(ac);
						}
						return ad > ae ? 1 : -1;
					});
				},
				embed : function (Z) {
					var aa = Z.parent;
					if (aa && aa.name == 'object') {
						var ab = aa.attributes.width,
						ac = aa.attributes.height;
						ab && (Z.attributes.width = ab);
						ac && (Z.attributes.height = ac);
					}
				},
				param : function (Z) {
					Z.children = [];
					Z.isEmpty = true;
					return Z;
				},
				a : function (Z) {
					if (!(Z.children.length || Z.attributes.name || Z.attributes['data-cke-saved-name']))
						return false;
				},
				span : function (Z) {
					if (Z.attributes['class'] == 'Apple-style-span')
						delete Z.name;
				},
				pre : function (Z) {
					h && v(Z);
				},
				html : function (Z) {
					delete Z.attributes.contenteditable;
					delete Z.attributes['class'];
				},
				body : function (Z) {
					delete Z.attributes.spellcheck;
					delete Z.attributes.contenteditable;
				},
				style : function (Z) {
					var aa = Z.children[0];
					aa && aa.value && (aa.value = j.trim(aa.value));
					if (!Z.attributes.type)
						Z.attributes.type = 'text/css';
				},
				title : function (Z) {
					var aa = Z.children[0];
					aa && (aa.value = Z.attributes['data-cke-title'] || '');
				}
			},
			attributes : {
				'class' : function (Z, aa) {
					return j.ltrim(Z.replace(/(?:^|\s+)cke_[^\s]*/g, '')) || false;
				}
			}
		};
		if (h)
			E.attributes.style = function (Z, aa) {
				return Z.replace(/(^|;)([^\:]+)/g, function (ab) {
					return ab.toLowerCase();
				});
			};
		function F(Z) {
			var aa = Z.attributes;
			if (aa.contenteditable != 'false')
				aa['data-cke-editable'] = aa.contenteditable ? 'true' : 1;
			aa.contenteditable = 'false';
		};
		function G(Z) {
			var aa = Z.attributes;
			switch (aa['data-cke-editable']) {
			case 'true':
				aa.contenteditable = 'true';
				break;
			case '1':
				delete aa.contenteditable;
				break;
			}
		};
		for (B in {
			input : 1,
			textarea : 1
		}) {
			C.elements[B] = F;
			E.elements[B] = G;
		}
		var H = /<(a|area|img|input|source)\b([^>]*)>/gi,
		I = /\b(on\w+|href|src|name)\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|(?:[^ "'>]+))/gi,
		J = /(?:<style(?=[ >])[^>]*>[\s\S]*<\/style>)|(?:<(:?link|meta|base)[^>]*>)/gi,
		K = /<cke:encoded>([^<]*)<\/cke:encoded>/gi,
		L = /(<\/?)((?:object|embed|param|html|body|head|title)[^>]*>)/gi,
		M = /(<\/?)cke:((?:html|body|head|title)[^>]*>)/gi,
		N = /<cke:(param|embed)([^>]*?)\/?>(?!\s*<\/cke:\1)/gi;
		function O(Z) {
			return Z.replace(H, function (aa, ab, ac) {
				return '<' + ab + ac.replace(I, function (ad, ae) {
					if (!/^on/.test(ae) && ac.indexOf('data-cke-saved-' + ae) == -1)
						return ' data-cke-saved-' + ad + ' data-cke-' + f.rnd + '-' + ad;
					return ad;
				}) + '>';
			});
		};
		function P(Z) {
			return Z.replace(J, function (aa) {
				return '<cke:encoded>' + encodeURIComponent(aa) + '</cke:encoded>';
			});
		};
		function Q(Z) {
			return Z.replace(K, function (aa, ab) {
				return decodeURIComponent(ab);
			});
		};
		function R(Z) {
			return Z.replace(L, '$1cke:$2');
		};
		function S(Z) {
			return Z.replace(M, '$1$2');
		};
		function T(Z) {
			return Z.replace(N, '<cke:$1$2></cke:$1>');
		};
		function U(Z) {
			return Z.replace(/(<pre\b[^>]*>)(\r\n|\n)/g, '$1$2$2');
		};
		function V(Z) {
			return Z.replace(/<!--(?!{cke_protected})[\s\S]+?-->/g, function (aa) {
				return '<!--' + s + '{C}' + encodeURIComponent(aa).replace(/--/g, '%2D%2D') + '-->';
			});
		};
		function W(Z) {
			return Z.replace(/<!--\{cke_protected\}\{C\}([\s\S]+?)-->/g, function (aa, ab) {
				return decodeURIComponent(ab);
			});
		};
		function X(Z, aa) {
			var ab = aa._.dataStore;
			return Z.replace(/<!--\{cke_protected\}([\s\S]+?)-->/g, function (ac, ad) {
				return decodeURIComponent(ad);
			}).replace(/\{cke_protected_(\d+)\}/g, function (ac, ad) {
				return ab && ab[ad] || '';
			});
		};
		function Y(Z, aa) {
			var ab = [],
			ac = aa.config.protectedSource,
			ad = aa._.dataStore || (aa._.dataStore = {
						id : 1
					}),
			ae = /<\!--\{cke_temp(comment)?\}(\d*?)-->/g,
			af = [/<script[\s\S]*?<\/script>/gi, /<noscript[\s\S]*?<\/noscript>/gi].concat(ac);
			Z = Z.replace(/<!--[\s\S]*?-->/g, function (ah) {
					return '<!--{cke_tempcomment}' + (ab.push(ah) - 1) + '-->';
				});
			for (var ag = 0; ag < af.length; ag++)
				Z = Z.replace(af[ag], function (ah) {
						ah = ah.replace(ae, function (ai, aj, ak) {
								return ab[ak];
							});
						return /cke_temp(comment)?/.test(ah) ? ah : '<!--{cke_temp}' + (ab.push(ah) - 1) + '-->';
					});
			Z = Z.replace(ae, function (ah, ai, aj) {
					return '<!--' + s + (ai ? '{C}' : '') + encodeURIComponent(ab[aj]).replace(/--/g, '%2D%2D') + '-->';
				});
			return Z.replace(/(['"]).*?\1/g, function (ah) {
				return ah.replace(/<!--\{cke_protected\}([\s\S]+?)-->/g, function (ai, aj) {
					ad[ad.id] = decodeURIComponent(aj);
					return '{cke_protected_' + ad.id++ + '}';
				});
			});
		};
		o.add('htmldataprocessor', {
			requires : ['htmlwriter'],
			init : function (Z) {
				var aa = Z.dataProcessor = new f.htmlDataProcessor(Z);
				aa.writer.forceSimpleAmpersand = Z.config.forceSimpleAmpersand;
				aa.dataFilter.addRules(C);
				aa.dataFilter.addRules(D);
				aa.htmlFilter.addRules(E);
				var ab = {
					elements : {}
					
				};
				for (B in A)
					ab.elements[B] = x(true, Z.config.fillEmptyBlocks);
				aa.htmlFilter.addRules(ab);
			},
			onLoad : function () {
				!('fillEmptyBlocks' in n) && (n.fillEmptyBlocks = 1);
			}
		});
		f.htmlDataProcessor = function (Z) {
			var aa = this;
			aa.editor = Z;
			aa.writer = new f.htmlWriter();
			aa.dataFilter = new f.htmlParser.filter();
			aa.htmlFilter = new f.htmlParser.filter();
		};
		f.htmlDataProcessor.prototype = {
			toHtml : function (Z, aa) {
				Z = Y(Z, this.editor);
				Z = O(Z);
				Z = P(Z);
				Z = R(Z);
				Z = T(Z);
				Z = U(Z);
				var ab = new m('div');
				ab.setHtml('a' + Z);
				Z = ab.getHtml().substr(1);
				Z = Z.replace(new RegExp(' data-cke-' + f.rnd + '-', 'ig'), ' ');
				Z = S(Z);
				Z = Q(Z);
				Z = W(Z);
				var ac = f.htmlParser.fragment.fromHtml(Z, aa),
				ad = new f.htmlParser.basicWriter();
				ac.writeHtml(ad, this.dataFilter);
				Z = ad.getHtml(true);
				Z = V(Z);
				return Z;
			},
			toDataFormat : function (Z, aa) {
				var ab = this.writer,
				ac = f.htmlParser.fragment.fromHtml(Z, aa);
				ab.reset();
				ac.writeHtml(ab, this.htmlFilter);
				var ad = ab.getHtml(true);
				ad = W(ad);
				ad = X(ad, this.editor);
				return ad;
			}
		};
	})();
	(function () {
		o.add('iframe', {
			requires : ['dialog', 'fakeobjects'],
			init : function (r) {
				var s = 'iframe',
				t = r.lang.iframe;
				f.dialog.add(s, this.path + 'dialogs/iframe.js');
				r.addCommand(s, new f.dialogCommand(s));
				r.addCss('img.cke_iframe{background-image: url(' + f.getUrl(this.path + 'images/placeholder.png') + ');' + 'background-position: center center;' + 'background-repeat: no-repeat;' + 'border: 1px solid #a9a9a9;' + 'width: 80px;' + 'height: 80px;' + '}');
				r.ui.addButton('Iframe', {
					label : t.toolbar,
					command : s
				});
				r.on('doubleclick', function (u) {
					var v = u.data.element;
					if (v.is('img') && v.data('cke-real-element-type') == 'iframe')
						u.data.dialog = 'iframe';
				});
				if (r.addMenuItems)
					r.addMenuItems({
						iframe : {
							label : t.title,
							command : 'iframe',
							group : 'image'
						}
					});
				if (r.contextMenu)
					r.contextMenu.addListener(function (u, v) {
						if (u && u.is('img') && u.data('cke-real-element-type') == 'iframe')
							return {
								iframe : 2
							};
					});
			},
			afterInit : function (r) {
				var s = r.dataProcessor,
				t = s && s.dataFilter;
				if (t)
					t.addRules({
						elements : {
							iframe : function (u) {
								return r.createFakeParserElement(u, 'cke_iframe', 'iframe', true);
							}
						}
					});
			}
		});
	})();
	(function () {
		o.add('image', {
			requires : ['dialog'],
			init : function (t) {
				var u = 'image';
				f.dialog.add(u, this.path + 'dialogs/image.js');
				t.addCommand(u, new f.dialogCommand(u));
				t.ui.addButton('Image', {
					label : t.lang.common.image,
					command : u
				});
				t.on('doubleclick', function (v) {
					var w = v.data.element;
					if (w.is('img') && !w.data('cke-realelement') && !w.isReadOnly())
						v.data.dialog = 'image';
				});
				if (t.addMenuItems)
					t.addMenuItems({
						image : {
							label : t.lang.image.menu,
							command : 'image',
							group : 'image'
						}
					});
				if (t.contextMenu)
					t.contextMenu.addListener(function (v, w) {
						if (r(t, v))
							return {
								image : 2
							};
					});
			},
			afterInit : function (t) {
				u('left');
				u('right');
				u('center');
				u('block');
				function u(v) {
					var w = t.getCommand('justify' + v);
					if (w) {
						if (v == 'left' || v == 'right')
							w.on('exec', function (x) {
								var y = r(t),
								z;
								if (y) {
									z = s(y);
									if (z == v) {
										y.removeStyle('float');
										if (v == s(y))
											y.removeAttribute('align');
									} else
										y.setStyle('float', v);
									x.cancel();
								}
							});
						w.on('refresh', function (x) {
							var y = r(t),
							z;
							if (y) {
								z = s(y);
								this.setState(z == v ? 1 : v == 'right' || v == 'left' ? 2 : 0);
								x.cancel();
							}
						});
					}
				};
			}
		});
		function r(t, u) {
			if (!u) {
				var v = t.getSelection();
				u = v.getType() == 3 && v.getSelectedElement();
			}
			if (u && u.is('img') && !u.data('cke-realelement') && !u.isReadOnly())
				return u;
		};
		function s(t) {
			var u = t.getStyle('float');
			if (u == 'inherit' || u == 'none')
				u = 0;
			if (!u)
				u = t.getAttribute('align');
			return u;
		};
	})();
	n.image_removeLinkByEmptyURL = true;
	(function () {
		var r = {
			ol : 1,
			ul : 1
		},
		s = i.walker.whitespaces(true),
		t = i.walker.bookmark(false, true);
		function u(y) {
			var G = this;
			if (y.editor.readOnly)
				return null;
			var z = y.editor,
			A = y.data.path,
			B = A && A.contains(r),
			C = A.block || A.blockLimit;
			if (B)
				return G.setState(2);
			if (!G.useIndentClasses && G.name == 'indent')
				return G.setState(2);
			if (!C)
				return G.setState(0);
			if (G.useIndentClasses) {
				var D = C.$.className.match(G.classNameRegex),
				E = 0;
				if (D) {
					D = D[1];
					E = G.indentClassMap[D];
				}
				if (G.name == 'outdent' && !E || G.name == 'indent' && E == z.config.indentClasses.length)
					return G.setState(0);
				return G.setState(2);
			} else {
				var F = parseInt(C.getStyle(w(C)), 10);
				if (isNaN(F))
					F = 0;
				if (F <= 0)
					return G.setState(0);
				return G.setState(2);
			}
		};
		function v(y, z) {
			var B = this;
			B.name = z;
			B.useIndentClasses = y.config.indentClasses && y.config.indentClasses.length > 0;
			if (B.useIndentClasses) {
				B.classNameRegex = new RegExp('(?:^|\\s+)(' + y.config.indentClasses.join('|') + ')(?=$|\\s)');
				B.indentClassMap = {};
				for (var A = 0; A < y.config.indentClasses.length; A++)
					B.indentClassMap[y.config.indentClasses[A]] = A + 1;
			}
			B.startDisabled = z == 'outdent';
		};
		function w(y, z) {
			return (z || y.getComputedStyle('direction')) == 'ltr' ? 'margin-left' : 'margin-right';
		};
		function x(y) {
			return y.type == 1 && y.is('li');
		};
		v.prototype = {
			exec : function (y) {
				var z = this,
				A = {};
				function B(R) {
					var S = H.startContainer,
					T = H.endContainer;
					while (S && !S.getParent().equals(R))
						S = S.getParent();
					while (T && !T.getParent().equals(R))
						T = T.getParent();
					if (!S || !T)
						return;
					var U = S,
					V = [],
					W = false;
					while (!W) {
						if (U.equals(T))
							W = true;
						V.push(U);
						U = U.getNext();
					}
					if (V.length < 1)
						return;
					var X = R.getParents(true);
					for (var Y = 0; Y < X.length; Y++) {
						if (X[Y].getName && r[X[Y].getName()]) {
							R = X[Y];
							break;
						}
					}
					var Z = z.name == 'indent' ? 1 : -1,
					aa = V[0],
					ab = V[V.length - 1],
					ac = o.list.listToArray(R, A),
					ad = ac[ab.getCustomData('listarray_index')].indent;
					for (Y = aa.getCustomData('listarray_index'); Y <= ab.getCustomData('listarray_index'); Y++) {
						ac[Y].indent += Z;
						if (Z > 0) {
							var ae = ac[Y].parent;
							ac[Y].parent = new m(ae.getName(), ae.getDocument());
						}
					}
					for (Y = ab.getCustomData('listarray_index') + 1; Y < ac.length && ac[Y].indent > ad; Y++)
						ac[Y].indent += Z;
					var af = o.list.arrayToList(ac, A, null, y.config.enterMode, R.getDirection());
					if (z.name == 'outdent') {
						var ag;
						if ((ag = R.getParent()) && ag.is('li')) {
							var ah = af.listNode.getChildren(),
							ai = [],
							aj = ah.count(),
							ak;
							for (Y = aj - 1; Y >= 0; Y--) {
								if ((ak = ah.getItem(Y)) && ak.is && ak.is('li'))
									ai.push(ak);
							}
						}
					}
					if (af)
						af.listNode.replace(R);
					if (ai && ai.length)
						for (Y = 0; Y < ai.length; Y++) {
							var al = ai[Y],
							am = al;
							while ((am = am.getNext()) && am.is && am.getName()in r) {
								if (h && !al.getFirst(function (an) {
										return s(an) && t(an);
									}))
									al.append(H.document.createText('\xa0'));
								al.append(am);
							}
							al.insertAfter(ag);
						}
				};
				function C() {
					var R = H.createIterator(),
					S = y.config.enterMode;
					R.enforceRealBlocks = true;
					R.enlargeBr = S != 2;
					var T;
					while (T = R.getNextParagraph(S == 1 ? 'p' : 'div'))
						D(T);
				};
				function D(R, S) {
					if (R.getCustomData('indent_processed'))
						return false;
					if (z.useIndentClasses) {
						var T = R.$.className.match(z.classNameRegex),
						U = 0;
						if (T) {
							T = T[1];
							U = z.indentClassMap[T];
						}
						if (z.name == 'outdent')
							U--;
						else
							U++;
						if (U < 0)
							return false;
						U = Math.min(U, y.config.indentClasses.length);
						U = Math.max(U, 0);
						R.$.className = j.ltrim(R.$.className.replace(z.classNameRegex, ''));
						if (U > 0)
							R.addClass(y.config.indentClasses[U - 1]);
					} else {
						var V = w(R, S),
						W = parseInt(R.getStyle(V), 10);
						if (isNaN(W))
							W = 0;
						var X = y.config.indentOffset || 40;
						W += (z.name == 'indent' ? 1 : -1) * X;
						if (W < 0)
							return false;
						W = Math.max(W, 0);
						W = Math.ceil(W / X) * X;
						R.setStyle(V, W ? W + (y.config.indentUnit || 'px') : '');
						if (R.getAttribute('style') === '')
							R.removeAttribute('style');
					}
					m.setMarker(A, R, 'indent_processed', 1);
					return true;
				};
				var E = y.getSelection(),
				F = E.createBookmarks(1),
				G = E && E.getRanges(1),
				H,
				I = G.createIterator();
				while (H = I.getNextRange()) {
					var J = H.getCommonAncestor(),
					K = J;
					while (K && !(K.type == 1 && r[K.getName()]))
						K = K.getParent();
					if (!K) {
						var L = H.getEnclosedNode();
						if (L && L.type == 1 && L.getName()in r) {
							H.setStartAt(L, 1);
							H.setEndAt(L, 2);
							K = L;
						}
					}
					if (K && H.startContainer.type == 1 && H.startContainer.getName()in r) {
						var M = new i.walker(H);
						M.evaluator = x;
						H.startContainer = M.next();
					}
					if (K && H.endContainer.type == 1 && H.endContainer.getName()in r) {
						M = new i.walker(H);
						M.evaluator = x;
						H.endContainer = M.previous();
					}
					if (K) {
						var N = K.getFirst(x),
						O = !!N.getNext(x),
						P = H.startContainer,
						Q = N.equals(P) || N.contains(P);
						if (!(Q && (z.name == 'indent' || z.useIndentClasses || parseInt(K.getStyle(w(K)), 10)) && D(K, !O && N.getDirection())))
							B(K);
					} else
						C();
				}
				m.clearAllMarkers(A);
				y.forceNextSelectionCheck();
				E.selectBookmarks(F);
			}
		};
		o.add('indent', {
			init : function (y) {
				var z = y.addCommand('indent', new v(y, 'indent')),
				A = y.addCommand('outdent', new v(y, 'outdent'));
				y.ui.addButton('Indent', {
					label : y.lang.indent,
					command : 'indent'
				});
				y.ui.addButton('Outdent', {
					label : y.lang.outdent,
					command : 'outdent'
				});
				y.on('selectionChange', j.bind(u, z));
				y.on('selectionChange', j.bind(u, A));
				if (g.ie6Compat || g.ie7Compat)
					y.addCss('ul,ol{\tmargin-left: 0px;\tpadding-left: 40px;}');
				y.on('dirChanged', function (B) {
					var C = new i.range(y.document);
					C.setStartBefore(B.data.node);
					C.setEndAfter(B.data.node);
					var D = new i.walker(C),
					E;
					while (E = D.next()) {
						if (E.type == 1) {
							if (!E.equals(B.data.node) && E.getDirection()) {
								C.setStartAfter(E);
								D = new i.walker(C);
								continue;
							}
							var F = y.config.indentClasses;
							if (F) {
								var G = B.data.dir == 'ltr' ? ['_rtl', ''] : ['', '_rtl'];
								for (var H = 0; H < F.length; H++) {
									if (E.hasClass(F[H] + G[0])) {
										E.removeClass(F[H] + G[0]);
										E.addClass(F[H] + G[1]);
									}
								}
							}
							var I = E.getStyle('margin-right'),
							J = E.getStyle('margin-left');
							I ? E.setStyle('margin-left', I) : E.removeStyle('margin-left');
							J ? E.setStyle('margin-right', J) : E.removeStyle('margin-right');
						}
					}
				});
			},
			requires : ['domiterator', 'list']
		});
	})();
	(function () {
		function r(v, w) {
			w = w === undefined || w;
			var x;
			if (w)
				x = v.getComputedStyle('text-align');
			else {
				while (!v.hasAttribute || !(v.hasAttribute('align') || v.getStyle('text-align'))) {
					var y = v.getParent();
					if (!y)
						break;
					v = y;
				}
				x = v.getStyle('text-align') || v.getAttribute('align') || '';
			}
			x && (x = x.replace(/(?:-(?:moz|webkit)-)?(?:start|auto)/i, ''));
			!x && w && (x = v.getComputedStyle('direction') == 'rtl' ? 'right' : 'left');
			return x;
		};
		function s(v) {
			if (v.editor.readOnly)
				return;
			v.editor.getCommand(this.name).refresh(v.data.path);
		};
		function t(v, w, x) {
			var z = this;
			z.editor = v;
			z.name = w;
			z.value = x;
			var y = v.config.justifyClasses;
			if (y) {
				switch (x) {
				case 'left':
					z.cssClassName = y[0];
					break;
				case 'center':
					z.cssClassName = y[1];
					break;
				case 'right':
					z.cssClassName = y[2];
					break;
				case 'justify':
					z.cssClassName = y[3];
					break;
				}
				z.cssClassRegex = new RegExp('(?:^|\\s+)(?:' + y.join('|') + ')(?=$|\\s)');
			}
		};
		function u(v) {
			var w = v.editor,
			x = new i.range(w.document);
			x.setStartBefore(v.data.node);
			x.setEndAfter(v.data.node);
			var y = new i.walker(x),
			z;
			while (z = y.next()) {
				if (z.type == 1) {
					if (!z.equals(v.data.node) && z.getDirection()) {
						x.setStartAfter(z);
						y = new i.walker(x);
						continue;
					}
					var A = w.config.justifyClasses;
					if (A)
						if (z.hasClass(A[0])) {
							z.removeClass(A[0]);
							z.addClass(A[2]);
						} else if (z.hasClass(A[2])) {
							z.removeClass(A[2]);
							z.addClass(A[0]);
						}
					var B = 'text-align',
					C = z.getStyle(B);
					if (C == 'left')
						z.setStyle(B, 'right');
					else if (C == 'right')
						z.setStyle(B, 'left');
				}
			}
		};
		t.prototype = {
			exec : function (v) {
				var H = this;
				var w = v.getSelection(),
				x = v.config.enterMode;
				if (!w)
					return;
				var y = w.createBookmarks(),
				z = w.getRanges(true),
				A = H.cssClassName,
				B,
				C,
				D = v.config.useComputedState;
				D = D === undefined || D;
				for (var E = z.length - 1; E >= 0; E--) {
					B = z[E].createIterator();
					B.enlargeBr = x != 2;
					while (C = B.getNextParagraph(x == 1 ? 'p' : 'div')) {
						C.removeAttribute('align');
						C.removeStyle('text-align');
						var F = A && (C.$.className = j.ltrim(C.$.className.replace(H.cssClassRegex, ''))),
						G = H.state == 2 && (!D || r(C, true) != H.value);
						if (A) {
							if (G)
								C.addClass(A);
							else if (!F)
								C.removeAttribute('class');
						} else if (G)
							C.setStyle('text-align', H.value);
					}
				}
				v.focus();
				v.forceNextSelectionCheck();
				w.selectBookmarks(y);
			},
			refresh : function (v) {
				var w = v.block || v.blockLimit;
				this.setState(w.getName() != 'body' && r(w, this.editor.config.useComputedState) == this.value ? 1 : 2);
			}
		};
		o.add('justify', {
			init : function (v) {
				var w = new t(v, 'justifyleft', 'left'),
				x = new t(v, 'justifycenter', 'center'),
				y = new t(v, 'justifyright', 'right'),
				z = new t(v, 'justifyblock', 'justify');
				v.addCommand('justifyleft', w);
				v.addCommand('justifycenter', x);
				v.addCommand('justifyright', y);
				v.addCommand('justifyblock', z);
				v.ui.addButton('JustifyLeft', {
					label : v.lang.justify.left,
					command : 'justifyleft'
				});
				v.ui.addButton('JustifyCenter', {
					label : v.lang.justify.center,
					command : 'justifycenter'
				});
				v.ui.addButton('JustifyRight', {
					label : v.lang.justify.right,
					command : 'justifyright'
				});
				v.ui.addButton('JustifyBlock', {
					label : v.lang.justify.block,
					command : 'justifyblock'
				});
				v.on('selectionChange', j.bind(s, w));
				v.on('selectionChange', j.bind(s, y));
				v.on('selectionChange', j.bind(s, x));
				v.on('selectionChange', j.bind(s, z));
				v.on('dirChanged', u);
			},
			requires : ['domiterator']
		});
	})();
	o.add('keystrokes', {
		beforeInit : function (r) {
			r.keystrokeHandler = new f.keystrokeHandler(r);
			r.specialKeys = {};
		},
		init : function (r) {
			var s = r.config.keystrokes,
			t = r.config.blockedKeystrokes,
			u = r.keystrokeHandler.keystrokes,
			v = r.keystrokeHandler.blockedKeystrokes;
			for (var w = 0; w < s.length; w++)
				u[s[w][0]] = s[w][1];
			for (w = 0; w < t.length; w++)
				v[t[w]] = 1;
		}
	});
	f.keystrokeHandler = function (r) {
		var s = this;
		if (r.keystrokeHandler)
			return r.keystrokeHandler;
		s.keystrokes = {};
		s.blockedKeystrokes = {};
		s._ = {
			editor : r
		};
		return s;
	};
	(function () {
		var r,
		s = function (u) {
			u = u.data;
			var v = u.getKeystroke(),
			w = this.keystrokes[v],
			x = this._.editor;
			r = x.fire('key', {
					keyCode : v
				}) === true;
			if (!r) {
				if (w) {
					var y = {
						from : 'keystrokeHandler'
					};
					r = x.execCommand(w, y) !== false;
				}
				if (!r) {
					var z = x.specialKeys[v];
					r = z && z(x) === true;
					if (!r)
						r = !!this.blockedKeystrokes[v];
				}
			}
			if (r)
				u.preventDefault(true);
			return !r;
		},
		t = function (u) {
			if (r) {
				r = false;
				u.data.preventDefault(true);
			}
		};
		f.keystrokeHandler.prototype = {
			attach : function (u) {
				u.on('keydown', s, this);
				if (g.opera || g.gecko && g.mac)
					u.on('keypress', t, this);
			}
		};
	})();
	n.blockedKeystrokes = [1000 + 66, 1000 + 73, 1000 + 85];
	n.keystrokes = [[4000 + 121, 'toolbarFocus'], [4000 + 122, 'elementsPathFocus'], [2000 + 121, 'contextMenu'], [1000 + 2000 + 121, 'contextMenu'], [1000 + 90, 'undo'], [1000 + 89, 'redo'], [1000 + 2000 + 90, 'redo'], [1000 + 76, 'link'], [1000 + 66, 'bold'], [1000 + 73, 'italic'], [1000 + 85, 'underline'], [4000 + (h || g.webkit ? 189 : 109), 'toolbarCollapse'], [4000 + 48, 'a11yHelp']];
	o.add('link', {
		requires : ['fakeobjects', 'dialog'],
		init : function (r) {
			r.addCommand('link', new f.dialogCommand('link'));
			r.addCommand('anchor', new f.dialogCommand('anchor'));
			r.addCommand('unlink', new f.unlinkCommand());
			r.addCommand('removeAnchor', new f.removeAnchorCommand());
			r.ui.addButton('Link', {
				label : r.lang.link.toolbar,
				command : 'link'
			});
			r.ui.addButton('Unlink', {
				label : r.lang.unlink,
				command : 'unlink'
			});
			r.ui.addButton('Anchor', {
				label : r.lang.anchor.toolbar,
				command : 'anchor'
			});
			f.dialog.add('link', this.path + 'dialogs/link.js');
			f.dialog.add('anchor', this.path + 'dialogs/anchor.js');
			var s = r.lang.dir == 'rtl' ? 'right' : 'left',
			t = 'background:url(' + f.getUrl(this.path + 'images/anchor.gif') + ') no-repeat ' + s + ' center;' + 'border:1px dotted #00f;';
			r.addCss('a.cke_anchor,a.cke_anchor_empty' + (h && g.version < 7 ? '' : ',a[name],a[data-cke-saved-name]') + '{' + t + 'padding-' + s + ':18px;' + 'cursor:auto;' + '}' + (h ? 'a.cke_anchor_empty{display:inline-block;}' : '') + 'img.cke_anchor' + '{' + t + 'width:16px;' + 'min-height:15px;' + 'height:1.15em;' + 'vertical-align:' + (g.opera ? 'middle' : 'text-bottom') + ';' + '}');
			r.on('selectionChange', function (u) {
				if (r.readOnly)
					return;
				var v = r.getCommand('unlink'),
				w = u.data.path.lastElement && u.data.path.lastElement.getAscendant('a', true);
				if (w && w.getName() == 'a' && w.getAttribute('href') && w.getChildCount())
					v.setState(2);
				else
					v.setState(0);
			});
			r.on('doubleclick', function (u) {
				var v = o.link.getSelectedLink(r) || u.data.element;
				if (!v.isReadOnly())
					if (v.is('a')) {
						u.data.dialog = v.getAttribute('name') && (!v.getAttribute('href') || !v.getChildCount()) ? 'anchor' : 'link';
						r.getSelection().selectElement(v);
					} else if (o.link.tryRestoreFakeAnchor(r, v))
						u.data.dialog = 'anchor';
			});
			if (r.addMenuItems)
				r.addMenuItems({
					anchor : {
						label : r.lang.anchor.menu,
						command : 'anchor',
						group : 'anchor',
						order : 1
					},
					removeAnchor : {
						label : r.lang.anchor.remove,
						command : 'removeAnchor',
						group : 'anchor',
						order : 5
					},
					link : {
						label : r.lang.link.menu,
						command : 'link',
						group : 'link',
						order : 1
					},
					unlink : {
						label : r.lang.unlink,
						command : 'unlink',
						group : 'link',
						order : 5
					}
				});
			if (r.contextMenu)
				r.contextMenu.addListener(function (u, v) {
					if (!u || u.isReadOnly())
						return null;
					var w = o.link.tryRestoreFakeAnchor(r, u);
					if (!w && !(w = o.link.getSelectedLink(r)))
						return null;
					var x = {};
					if (w.getAttribute('href') && w.getChildCount())
						x = {
							link : 2,
							unlink : 2
						};
					if (w && w.hasAttribute('name'))
						x.anchor = x.removeAnchor = 2;
					return x;
				});
		},
		afterInit : function (r) {
			var s = r.dataProcessor,
			t = s && s.dataFilter,
			u = s && s.htmlFilter,
			v = r._.elementsPath && r._.elementsPath.filters;
			if (t)
				t.addRules({
					elements : {
						a : function (w) {
							var x = w.attributes;
							if (!x.name)
								return null;
							var y = !w.children.length;
							if (o.link.synAnchorSelector) {
								var z = y ? 'cke_anchor_empty' : 'cke_anchor',
								A = x['class'];
								if (x.name && (!A || A.indexOf(z) < 0))
									x['class'] = (A || '') + ' ' + z;
								if (y && o.link.emptyAnchorFix) {
									x.contenteditable = 'false';
									x['data-cke-editable'] = 1;
								}
							} else if (o.link.fakeAnchor && y)
								return r.createFakeParserElement(w, 'cke_anchor', 'anchor');
							return null;
						}
					}
				});
			if (o.link.emptyAnchorFix && u)
				u.addRules({
					elements : {
						a : function (w) {
							delete w.attributes.contenteditable;
						}
					}
				});
			if (v)
				v.push(function (w, x) {
					if (x == 'a')
						if (o.link.tryRestoreFakeAnchor(r, w) || w.getAttribute('name') && (!w.getAttribute('href') || !w.getChildCount()))
							return 'anchor';
				});
		}
	});
	o.link = {
		getSelectedLink : function (r) {
			try {
				var s = r.getSelection();
				if (s.getType() == 3) {
					var t = s.getSelectedElement();
					if (t.is('a'))
						return t;
				}
				var u = s.getRanges(true)[0];
				u.shrink(2);
				var v = u.getCommonAncestor();
				return v.getAscendant('a', true);
			} catch (w) {
				return null;
			}
		},
		fakeAnchor : g.opera || g.webkit,
		synAnchorSelector : h,
		emptyAnchorFix : h && g.version < 8,
		tryRestoreFakeAnchor : function (r, s) {
			if (s && s.data('cke-real-element-type') && s.data('cke-real-element-type') == 'anchor') {
				var t = r.restoreRealElement(s);
				if (t.data('cke-saved-name'))
					return t;
			}
		}
	};
	f.unlinkCommand = function () {};
	f.unlinkCommand.prototype = {
		exec : function (r) {
			var s = r.getSelection(),
			t = s.createBookmarks(),
			u = s.getRanges(),
			v,
			w;
			for (var x = 0; x < u.length; x++) {
				v = u[x].getCommonAncestor(true);
				w = v.getAscendant('a', true);
				if (!w)
					continue;
				u[x].selectNodeContents(w);
			}
			s.selectRanges(u);
			r.document.$.execCommand('unlink', false, null);
			s.selectBookmarks(t);
		},
		startDisabled : true
	};
	f.removeAnchorCommand = function () {};
	f.removeAnchorCommand.prototype = {
		exec : function (r) {
			var s = r.getSelection(),
			t = s.createBookmarks(),
			u;
			if (s && (u = s.getSelectedElement()) && (o.link.fakeAnchor && !u.getChildCount() ? o.link.tryRestoreFakeAnchor(r, u) : u.is('a')))
				u.remove(1);
			else if (u = o.link.getSelectedLink(r))
				if (u.hasAttribute('href')) {
					u.removeAttributes({
						name : 1,
						'data-cke-saved-name' : 1
					});
					u.removeClass('cke_anchor');
				} else
					u.remove(1);
			s.selectBookmarks(t);
		}
	};
	j.extend(n, {
		linkShowAdvancedTab : true,
		linkShowTargetTab : true
	});
	(function () {
		var r = {
			ol : 1,
			ul : 1
		},
		s = /^[\n\r\t ]*$/,
		t = i.walker.whitespaces(),
		u = i.walker.bookmark(),
		v = function (S) {
			return !(t(S) || u(S));
		},
		w = i.walker.bogus();
		function x(S) {
			var T,
			U,
			V;
			if (T = S.getDirection()) {
				U = S.getParent();
				while (U && !(V = U.getDirection()))
					U = U.getParent();
				if (T == V)
					S.removeAttribute('dir');
			}
		};
		function y(S, T) {
			var U = S.getAttribute('style');
			U && T.setAttribute('style', U.replace(/([^;])$/, '$1;') + (T.getAttribute('style') || ''));
		};
		o.list = {
			listToArray : function (S, T, U, V, W) {
				if (!r[S.getName()])
					return [];
				if (!V)
					V = 0;
				if (!U)
					U = [];
				for (var X = 0, Y = S.getChildCount(); X < Y; X++) {
					var Z = S.getChild(X);
					if (Z.type == 1 && Z.getName()in k.$list)
						o.list.listToArray(Z, T, U, V + 1);
					if (Z.$.nodeName.toLowerCase() != 'li')
						continue;
					var aa = {
						parent : S,
						indent : V,
						element : Z,
						contents : []
					};
					if (!W) {
						aa.grandparent = S.getParent();
						if (aa.grandparent && aa.grandparent.$.nodeName.toLowerCase() == 'li')
							aa.grandparent = aa.grandparent.getParent();
					} else
						aa.grandparent = W;
					if (T)
						m.setMarker(T, Z, 'listarray_index', U.length);
					U.push(aa);
					for (var ab = 0, ac = Z.getChildCount(), ad; ab < ac; ab++) {
						ad = Z.getChild(ab);
						if (ad.type == 1 && r[ad.getName()])
							o.list.listToArray(ad, T, U, V + 1, aa.grandparent);
						else
							aa.contents.push(ad);
					}
				}
				return U;
			},
			arrayToList : function (S, T, U, V, W) {
				if (!U)
					U = 0;
				if (!S || S.length < U + 1)
					return null;
				var X,
				Y = S[U].parent.getDocument(),
				Z = new i.documentFragment(Y),
				aa = null,
				ab = U,
				ac = Math.max(S[U].indent, 0),
				ad = null,
				ae,
				af,
				ag = V == 1 ? 'p' : 'div';
				while (1) {
					var ah = S[ab],
					ai = ah.grandparent;
					ae = ah.element.getDirection(1);
					if (ah.indent == ac) {
						if (!aa || S[ab].parent.getName() != aa.getName()) {
							aa = S[ab].parent.clone(false, 1);
							W && aa.setAttribute('dir', W);
							Z.append(aa);
						}
						ad = aa.append(ah.element.clone(0, 1));
						if (ae != aa.getDirection(1))
							ad.setAttribute('dir', ae);
						for (X = 0; X < ah.contents.length; X++)
							ad.append(ah.contents[X].clone(1, 1));
						ab++;
					} else if (ah.indent == Math.max(ac, 0) + 1) {
						var aj = S[ab - 1].element.getDirection(1),
						ak = o.list.arrayToList(S, null, ab, V, aj != ae ? ae : null);
						if (!ad.getChildCount() && h && !(Y.$.documentMode > 7))
							ad.append(Y.createText('\xa0'));
						ad.append(ak.listNode);
						ab = ak.nextIndex;
					} else if (ah.indent == -1 && !U && ai) {
						if (r[ai.getName()]) {
							ad = ah.element.clone(false, true);
							if (ae != ai.getDirection(1))
								ad.setAttribute('dir', ae);
						} else
							ad = new i.documentFragment(Y);
						var al = ai.getDirection(1) != ae,
						am = ah.element,
						an = am.getAttribute('class'),
						ao = am.getAttribute('style'),
						ap = ad.type == 11 && (V != 2 || al || ao || an),
						aq,
						ar = ah.contents.length;
						for (X = 0; X < ar; X++) {
							aq = ah.contents[X];
							if (aq.type == 1 && aq.isBlockBoundary()) {
								if (al && !aq.getDirection())
									aq.setAttribute('dir', ae);
								y(am, aq);
								an && aq.addClass(an);
							} else if (ap) {
								if (!af) {
									af = Y.createElement(ag);
									al && af.setAttribute('dir', ae);
								}
								ao && af.setAttribute('style', ao);
								an && af.setAttribute('class', an);
								af.append(aq.clone(1, 1));
							}
							ad.append(af || aq.clone(1, 1));
						}
						if (ad.type == 11 && ab != S.length - 1) {
							var as = ad.getLast();
							if (as && as.type == 1 && as.getAttribute('type') == '_moz')
								as.remove();
							if (!(as = ad.getLast(v) && as.type == 1 && as.getName()in k.$block))
								ad.append(Y.createElement('br'));
						}
						var at = ad.$.nodeName.toLowerCase();
						if (!h && (at == 'div' || at == 'p'))
							ad.appendBogus();
						Z.append(ad);
						aa = null;
						ab++;
					} else
						return null;
					af = null;
					if (S.length <= ab || Math.max(S[ab].indent, 0) < ac)
						break;
				}
				if (T) {
					var au = Z.getFirst(),
					av = S[0].parent;
					while (au) {
						if (au.type == 1) {
							m.clearMarkers(T, au);
							if (au.getName()in k.$listItem)
								x(au);
						}
						au = au.getNextSourceNode();
					}
				}
				return {
					listNode : Z,
					nextIndex : ab
				};
			}
		};
		function z(S) {
			if (S.editor.readOnly)
				return null;
			var T = S.data.path,
			U = T.blockLimit,
			V = T.elements,
			W,
			X;
			for (X = 0; X < V.length && (W = V[X]) && !W.equals(U); X++) {
				if (r[V[X].getName()])
					return this.setState(this.type == V[X].getName() ? 1 : 2);
			}
			return this.setState(2);
		};
		function A(S, T, U, V) {
			var W = o.list.listToArray(T.root, U),
			X = [];
			for (var Y = 0; Y < T.contents.length; Y++) {
				var Z = T.contents[Y];
				Z = Z.getAscendant('li', true);
				if (!Z || Z.getCustomData('list_item_processed'))
					continue;
				X.push(Z);
				m.setMarker(U, Z, 'list_item_processed', true);
			}
			var aa = T.root,
			ab = aa.getDocument(),
			ac,
			ad;
			for (Y = 0; Y < X.length; Y++) {
				var ae = X[Y].getCustomData('listarray_index');
				ac = W[ae].parent;
				if (!ac.is(this.type)) {
					ad = ab.createElement(this.type);
					ac.copyAttributes(ad, {
						start : 1,
						type : 1
					});
					ad.removeStyle('list-style-type');
					W[ae].parent = ad;
				}
			}
			var af = o.list.arrayToList(W, U, null, S.config.enterMode),
			ag,
			ah = af.listNode.getChildCount();
			for (Y = 0; Y < ah && (ag = af.listNode.getChild(Y)); Y++) {
				if (ag.getName() == this.type)
					V.push(ag);
			}
			af.listNode.replace(T.root);
		};
		var B = /^h[1-6]$/;
		function C(S, T, U) {
			var V = T.contents,
			W = T.root.getDocument(),
			X = [];
			if (V.length == 1 && V[0].equals(T.root)) {
				var Y = W.createElement('div');
				V[0].moveChildren && V[0].moveChildren(Y);
				V[0].append(Y);
				V[0] = Y;
			}
			var Z = T.contents[0].getParent();
			for (var aa = 0; aa < V.length; aa++)
				Z = Z.getCommonAncestor(V[aa].getParent());
			var ab = S.config.useComputedState,
			ac,
			ad;
			ab = ab === undefined || ab;
			for (aa = 0; aa < V.length; aa++) {
				var ae = V[aa],
				af;
				while (af = ae.getParent()) {
					if (af.equals(Z)) {
						X.push(ae);
						if (!ad && ae.getDirection())
							ad = 1;
						var ag = ae.getDirection(ab);
						if (ac !== null)
							if (ac && ac != ag)
								ac = null;
							else
								ac = ag;
						break;
					}
					ae = af;
				}
			}
			if (X.length < 1)
				return;
			var ah = X[X.length - 1].getNext(),
			ai = W.createElement(this.type);
			U.push(ai);
			var aj,
			ak;
			while (X.length) {
				aj = X.shift();
				ak = W.createElement('li');
				if (aj.is('pre') || B.test(aj.getName()))
					aj.appendTo(ak);
				else {
					aj.copyAttributes(ak);
					if (ac && aj.getDirection()) {
						ak.removeStyle('direction');
						ak.removeAttribute('dir');
					}
					aj.moveChildren(ak);
					aj.remove();
				}
				ak.appendTo(ai);
			}
			if (ac && ad)
				ai.setAttribute('dir', ac);
			if (ah)
				ai.insertBefore(ah);
			else
				ai.appendTo(Z);
		};
		function D(S, T, U) {
			var V = o.list.listToArray(T.root, U),
			W = [];
			for (var X = 0; X < T.contents.length; X++) {
				var Y = T.contents[X];
				Y = Y.getAscendant('li', true);
				if (!Y || Y.getCustomData('list_item_processed'))
					continue;
				W.push(Y);
				m.setMarker(U, Y, 'list_item_processed', true);
			}
			var Z = null;
			for (X = 0; X < W.length; X++) {
				var aa = W[X].getCustomData('listarray_index');
				V[aa].indent = -1;
				Z = aa;
			}
			for (X = Z + 1; X < V.length; X++) {
				if (V[X].indent > V[X - 1].indent + 1) {
					var ab = V[X - 1].indent + 1 - V[X].indent,
					ac = V[X].indent;
					while (V[X] && V[X].indent >= ac) {
						V[X].indent += ab;
						X++;
					}
					X--;
				}
			}
			var ad = o.list.arrayToList(V, U, null, S.config.enterMode, T.root.getAttribute('dir')),
			ae = ad.listNode,
			af,
			ag;
			function ah(ai) {
				if ((af = ae[ai ? 'getFirst' : 'getLast']()) && !(af.is && af.isBlockBoundary()) && (ag = T.root[ai ? 'getPrevious' : 'getNext'](i.walker.whitespaces(true))) && !(ag.is && ag.isBlockBoundary({
							br : 1
						})))
					S.document.createElement('br')[ai ? 'insertBefore' : 'insertAfter'](af);
			};
			ah(true);
			ah();
			ae.replace(T.root);
		};
		function E(S, T) {
			this.name = S;
			this.type = T;
		};
		var F = i.walker.nodeType(1);
		function G(S, T, U, V) {
			var W,
			X;
			while (W = S[V ? 'getLast' : 'getFirst'](F)) {
				if ((X = W.getDirection(1)) !== T.getDirection(1))
					W.setAttribute('dir', X);
				W.remove();
				U ? W[V ? 'insertBefore' : 'insertAfter'](U) : T.append(W, V);
			}
		};
		E.prototype = {
			exec : function (S) {
				var av = this;
				var T = S.document,
				U = S.config,
				V = S.getSelection(),
				W = V && V.getRanges(true);
				if (!W || W.length < 1)
					return;
				if (av.state == 2) {
					var X = T.getBody();
					if (!X.getFirst(v)) {
						U.enterMode == 2 ? X.appendBogus() : W[0].fixBlock(1, U.enterMode == 1 ? 'p' : 'div');
						V.selectRanges(W);
					} else {
						var Y = W.length == 1 && W[0],
						Z = Y && Y.getEnclosedNode();
						if (Z && Z.is && av.type == Z.getName())
							av.setState(1);
					}
				}
				var aa = V.createBookmarks(true),
				ab = [],
				ac = {},
				ad = W.createIterator(),
				ae = 0;
				while ((Y = ad.getNextRange()) && ++ae) {
					var af = Y.getBoundaryNodes(),
					ag = af.startNode,
					ah = af.endNode;
					if (ag.type == 1 && ag.getName() == 'td')
						Y.setStartAt(af.startNode, 1);
					if (ah.type == 1 && ah.getName() == 'td')
						Y.setEndAt(af.endNode, 2);
					var ai = Y.createIterator(),
					aj;
					ai.forceBrBreak = av.state == 2;
					while (aj = ai.getNextParagraph()) {
						if (aj.getCustomData('list_block'))
							continue;
						else
							m.setMarker(ac, aj, 'list_block', 1);
						var ak = new i.elementPath(aj),
						al = ak.elements,
						am = al.length,
						an = null,
						ao = 0,
						ap = ak.blockLimit,
						aq;
						for (var ar = am - 1; ar >= 0 && (aq = al[ar]); ar--) {
							if (r[aq.getName()] && ap.contains(aq)) {
								ap.removeCustomData('list_group_object_' + ae);
								var as = aq.getCustomData('list_group_object');
								if (as)
									as.contents.push(aj);
								else {
									as = {
										root : aq,
										contents : [aj]
									};
									ab.push(as);
									m.setMarker(ac, aq, 'list_group_object', as);
								}
								ao = 1;
								break;
							}
						}
						if (ao)
							continue;
						var at = ap;
						if (at.getCustomData('list_group_object_' + ae))
							at.getCustomData('list_group_object_' + ae).contents.push(aj);
						else {
							as = {
								root : at,
								contents : [aj]
							};
							m.setMarker(ac, at, 'list_group_object_' + ae, as);
							ab.push(as);
						}
					}
				}
				var au = [];
				while (ab.length > 0) {
					as = ab.shift();
					if (av.state == 2) {
						if (r[as.root.getName()])
							A.call(av, S, as, ac, au);
						else
							C.call(av, S, as, au);
					} else if (av.state == 1 && r[as.root.getName()])
						D.call(av, S, as, ac);
				}
				for (ar = 0;
					ar < au.length; ar++)
					H(au[ar]);
				m.clearAllMarkers(ac);
				V.selectBookmarks(aa);
				S.focus();
			}
		};
		function H(S) {
			var T;
			(T = function (U) {
				var V = S[U ? 'getPrevious' : 'getNext'](v);
				if (V && V.type == 1 && V.is(S.getName())) {
					G(S, V, null, !U);
					S.remove();
					S = V;
				}
			})();
			T(1);
		};
		var I = k,
		J = /[\t\r\n ]*(?:&nbsp;|\xa0)$/;
		function K(S, T) {
			var U,
			V = S.children,
			W = V.length;
			for (var X = 0; X < W; X++) {
				U = V[X];
				if (U.name && U.name in T)
					return X;
			}
			return W;
		};
		function L(S) {
			return function (T) {
				var U = T.children,
				V = K(T, I.$list),
				W = U[V],
				X = W && W.previous,
				Y;
				if (X && (X.name && X.name == 'br' || X.value && (Y = X.value.match(J)))) {
					var Z = X;
					if (!(Y && Y.index) && Z == U[0])
						U[0] = S || h ? new f.htmlParser.text('\xa0') : new f.htmlParser.element('br', {});
					else if (Z.name == 'br')
						U.splice(V - 1, 1);
					else
						Z.value = Z.value.replace(J, '');
				}
			};
		};
		var M = {
			elements : {}
			
		};
		for (var N in I.$listItem)
			M.elements[N] = L();
		var O = {
			elements : {}
			
		};
		for (N in I.$listItem)
			O.elements[N] = L(true);
		function P(S) {
			return S.type == 1 && (S.getName()in k.$block || S.getName()in k.$listItem) && k[S.getName()]['#'];
		};
		function Q(S, T, U) {
			S.fire('saveSnapshot');
			U.enlarge(3);
			var V = U.extractContents();
			T.trim(false, true);
			var W = T.createBookmark(),
			X = new i.elementPath(T.startContainer),
			Y = X.block,
			Z = X.lastElement.getAscendant('li', 1) || Y,
			aa = new i.elementPath(U.startContainer),
			ab = aa.contains(k.$listItem),
			ac = aa.contains(k.$list),
			ad;
			if (Y) {
				var ae = Y.getBogus();
				ae && ae.remove();
			} else if (ac) {
				ad = ac.getPrevious(v);
				if (ad && w(ad))
					ad.remove();
			}
			ad = V.getLast();
			if (ad && ad.type == 1 && ad.is('br'))
				ad.remove();
			var af = T.startContainer.getChild(T.startOffset);
			if (af)
				V.insertBefore(af);
			else
				T.startContainer.append(V);
			if (ab) {
				var ag = R(ab);
				if (ag)
					if (Z.contains(ab)) {
						G(ag, ab.getParent(), ab);
						ag.remove();
					} else
						Z.append(ag);
			}
			while (U.checkStartOfBlock() && U.checkEndOfBlock()) {
				aa = new i.elementPath(U.startContainer);
				var ah = aa.block,
				ai;
				if (ah.is('li')) {
					ai = ah.getParent();
					if (ah.equals(ai.getLast(v)) && ah.equals(ai.getFirst(v)))
						ah = ai;
				}
				U.moveToPosition(ah, 3);
				ah.remove();
			}
			var aj = U.clone(),
			ak = S.document.getBody();
			aj.setEndAt(ak, 2);
			var al = new i.walker(aj);
			al.evaluator = function (an) {
				return v(an) && !w(an);
			};
			var am = al.next();
			if (am && am.type == 1 && am.getName()in k.$list)
				H(am);
			T.moveToBookmark(W);
			T.select();
			S.selectionChange(1);
			S.fire('saveSnapshot');
		};
		function R(S) {
			var T = S.getLast(v);
			return T && T.type == 1 && T.getName()in r ? T : null;
		};
		o.add('list', {
			init : function (S) {
				var T = S.addCommand('numberedlist', new E('numberedlist', 'ol')),
				U = S.addCommand('bulletedlist', new E('bulletedlist', 'ul'));
				S.ui.addButton('NumberedList', {
					label : S.lang.numberedlist,
					command : 'numberedlist'
				});
				S.ui.addButton('BulletedList', {
					label : S.lang.bulletedlist,
					command : 'bulletedlist'
				});
				S.on('selectionChange', j.bind(z, T));
				S.on('selectionChange', j.bind(z, U));
				S.on('key', function (V) {
					var W = V.data.keyCode;
					if (S.mode == 'wysiwyg' && W in {
						8 : 1,
						46 : 1
					}) {
						var X = S.getSelection(),
						Y = X.getRanges()[0];
						if (!Y.collapsed)
							return;
						var Z = new i.elementPath(Y.startContainer),
						aa = W == 8,
						ab = S.document.getBody(),
						ac = new i.walker(Y.clone());
						ac.evaluator = function (an) {
							return v(an) && !w(an);
						};
						ac.guard = function (an, ao) {
							return !(ao && an.type == 1 && an.is('table'));
						};
						var ad = Y.clone();
						if (aa) {
							var ae,
							af;
							if ((ae = Z.contains(r)) && Y.checkBoundaryOfElement(ae, 1) && (ae = ae.getParent()) && ae.is('li') && (ae = R(ae))) {
								af = ae;
								ae = ae.getPrevious(v);
								ad.moveToPosition(ae && w(ae) ? ae : af, 3);
							} else {
								ac.range.setStartAt(ab, 1);
								ac.range.setEnd(Y.startContainer, Y.startOffset);
								ae = ac.previous();
								if (ae && ae.type == 1 && (ae.getName()in r || ae.is('li'))) {
									if (!ae.is('li')) {
										ac.range.selectNodeContents(ae);
										ac.reset();
										ac.evaluator = P;
										ae = ac.previous();
									}
									af = ae;
									ad.moveToElementEditEnd(af);
								}
							}
							if (af) {
								Q(S, ad, Y);
								V.cancel();
							} else {
								var ag = Z.contains(r),
								ah;
								if (ag && Y.checkBoundaryOfElement(ag, 1)) {
									ah = ag.getFirst(v);
									if (Y.checkBoundaryOfElement(ah, 1)) {
										ae = ag.getPrevious(v);
										if (R(ah)) {
											if (ae) {
												Y.moveToElementEditEnd(ae);
												Y.select();
											}
											V.cancel();
										} else {
											S.execCommand('outdent');
											V.cancel();
										}
									}
								}
							}
						} else {
							var ai,
							aj;
							ah = Y.startContainer.getAscendant('li', 1);
							if (ah) {
								ac.range.setEndAt(ab, 2);
								var ak = ah.getLast(v),
								al = ak && P(ak) ? ak : ah,
								am = 0;
								ai = ac.next();
								if (ai && ai.type == 1 && ai.getName()in r && ai.equals(ak)) {
									am = 1;
									ai = ac.next();
								} else if (Y.checkBoundaryOfElement(al, 2))
									am = 1;
								if (am && ai) {
									aj = Y.clone();
									aj.moveToElementEditStart(ai);
									Q(S, ad, aj);
									V.cancel();
								}
							} else {
								ac.range.setEndAt(ab, 2);
								ai = ac.next();
								if (ai && ai.type == 1 && ai.getName()in r) {
									ai = ai.getFirst(v);
									if (Z.block && Y.checkStartOfBlock() && Y.checkEndOfBlock()) {
										Z.block.remove();
										Y.moveToElementEditStart(ai);
										Y.select();
										V.cancel();
									} else if (R(ai)) {
										Y.moveToElementEditStart(ai);
										Y.select();
										V.cancel();
									} else {
										aj = Y.clone();
										aj.moveToElementEditStart(ai);
										Q(S, ad, aj);
										V.cancel();
									}
								}
							}
						}
						setTimeout(function () {
							S.selectionChange(1);
						});
					}
				});
			},
			afterInit : function (S) {
				var T = S.dataProcessor;
				if (T) {
					T.dataFilter.addRules(M);
					T.htmlFilter.addRules(O);
				}
			},
			requires : ['domiterator']
		});
	})();
	(function () {
		o.liststyle = {
			requires : ['dialog'],
			init : function (r) {
				r.addCommand('numberedListStyle', new f.dialogCommand('numberedListStyle'));
				f.dialog.add('numberedListStyle', this.path + 'dialogs/liststyle.js');
				r.addCommand('bulletedListStyle', new f.dialogCommand('bulletedListStyle'));
				f.dialog.add('bulletedListStyle', this.path + 'dialogs/liststyle.js');
				if (r.addMenuItems) {
					r.addMenuGroup('list', 108);
					r.addMenuItems({
						numberedlist : {
							label : r.lang.list.numberedTitle,
							group : 'list',
							command : 'numberedListStyle'
						},
						bulletedlist : {
							label : r.lang.list.bulletedTitle,
							group : 'list',
							command : 'bulletedListStyle'
						}
					});
				}
				if (r.contextMenu)
					r.contextMenu.addListener(function (s, t) {
						if (!s || s.isReadOnly())
							return null;
						while (s) {
							var u = s.getName();
							if (u == 'ol')
								return {
									numberedlist : 2
								};
							else if (u == 'ul')
								return {
									bulletedlist : 2
								};
							s = s.getParent();
						}
						return null;
					});
			}
		};
		o.add('liststyle', o.liststyle);
	})();
	(function () {
		function r(x) {
			if (!x || x.type != 1 || x.getName() != 'form')
				return [];
			var y = [],
			z = ['style', 'className'];
			for (var A = 0; A < z.length; A++) {
				var B = z[A],
				C = x.$.elements.namedItem(B);
				if (C) {
					var D = new m(C);
					y.push([D, D.nextSibling]);
					D.remove();
				}
			}
			return y;
		};
		function s(x, y) {
			if (!x || x.type != 1 || x.getName() != 'form')
				return;
			if (y.length > 0)
				for (var z = y.length - 1; z >= 0; z--) {
					var A = y[z][0],
					B = y[z][1];
					if (B)
						A.insertBefore(B);
					else
						A.appendTo(x);
				}
		};
		function t(x, y) {
			var z = r(x),
			A = {},
			B = x.$;
			if (!y) {
				A['class'] = B.className || '';
				B.className = '';
			}
			A.inline = B.style.cssText || '';
			if (!y)
				B.style.cssText = 'position: static; overflow: visible';
			s(z);
			return A;
		};
		function u(x, y) {
			var z = r(x),
			A = x.$;
			if ('class' in y)
				A.className = y['class'];
			if ('inline' in y)
				A.style.cssText = y.inline;
			s(z);
		};
		function v(x) {
			var y = f.instances;
			for (var z in y) {
				var A = y[z];
				if (A.mode == 'wysiwyg' && !A.readOnly) {
					var B = A.document.getBody();
					B.setAttribute('contentEditable', false);
					B.setAttribute('contentEditable', true);
				}
			}
			if (x.focusManager.hasFocus) {
				x.toolbox.focus();
				x.focus();
			}
		};
		function w(x) {
			if (!h || g.version > 6)
				return null;
			var y = m.createFromHtml('<iframe frameborder="0" tabindex="-1" src="javascript:void((function(){document.open();' + (g.isCustomDomain() ? "document.domain='" + this.getDocument().$.domain + "';" : '') + 'document.close();' + '})())"' + ' style="display:block;position:absolute;z-index:-1;' + 'progid:DXImageTransform.Microsoft.Alpha(opacity=0);' + '"></iframe>');
			return x.append(y, true);
		};
		o.add('maximize', {
			init : function (x) {
				var y = x.lang,
				z = f.document,
				A = z.getWindow(),
				B,
				C,
				D,
				E;
				function F() {
					var H = A.getViewPaneSize();
					E && E.setStyles({
						width : H.width + 'px',
						height : H.height + 'px'
					});
					x.resize(H.width, H.height, null, true);
				};
				var G = 2;
				x.addCommand('maximize', {
					modes : {
						wysiwyg : !g.iOS,
						source : !g.iOS
					},
					readOnly : 1,
					editorFocus : false,
					exec : function () {
						var H = x.container.getChild(1),
						I = x.getThemeSpace('contents');
						if (x.mode == 'wysiwyg') {
							var J = x.getSelection();
							B = J && J.getRanges();
							C = A.getScrollPosition();
						} else {
							var K = x.textarea.$;
							B = !h && [K.selectionStart, K.selectionEnd];
							C = [K.scrollLeft, K.scrollTop];
						}
						if (this.state == 2) {
							A.on('resize', F);
							D = A.getScrollPosition();
							var L = x.container;
							while (L = L.getParent()) {
								L.setCustomData('maximize_saved_styles', t(L));
								L.setStyle('z-index', x.config.baseFloatZIndex - 1);
							}
							I.setCustomData('maximize_saved_styles', t(I, true));
							H.setCustomData('maximize_saved_styles', t(H, true));
							var M = {
								overflow : g.webkit ? '' : 'hidden',
								width : 0,
								height : 0
							};
							z.getDocumentElement().setStyles(M);
							!g.gecko && z.getDocumentElement().setStyle('position', 'fixed');
							!(g.gecko && g.quirks) && z.getBody().setStyles(M);
							h ? setTimeout(function () {
								A.$.scrollTo(0, 0);
							}, 0) : A.$.scrollTo(0, 0);
							H.setStyle('position', g.gecko && g.quirks ? 'fixed' : 'absolute');
							H.$.offsetLeft;
							H.setStyles({
								'z-index' : x.config.baseFloatZIndex - 1,
								left : '0px',
								top : '0px'
							});
							E = w(H);
							H.addClass('cke_maximized');
							F();
							var N = H.getDocumentPosition();
							H.setStyles({
								left : -1 * N.x + 'px',
								top : -1 * N.y + 'px'
							});
							g.gecko && v(x);
						} else if (this.state == 1) {
							A.removeListener('resize', F);
							var O = [I, H];
							for (var P = 0; P < O.length; P++) {
								u(O[P], O[P].getCustomData('maximize_saved_styles'));
								O[P].removeCustomData('maximize_saved_styles');
							}
							L = x.container;
							while (L = L.getParent()) {
								u(L, L.getCustomData('maximize_saved_styles'));
								L.removeCustomData('maximize_saved_styles');
							}
							h ? setTimeout(function () {
								A.$.scrollTo(D.x, D.y);
							}, 0) : A.$.scrollTo(D.x, D.y);
							H.removeClass('cke_maximized');
							if (g.webkit) {
								H.setStyle('display', 'inline');
								setTimeout(function () {
									H.setStyle('display', 'block');
								}, 0);
							}
							if (E) {
								E.remove();
								E = null;
							}
							x.fire('resize');
						}
						this.toggleState();
						var Q = this.uiItems[0];
						if (Q) {
							var R = this.state == 2 ? y.maximize : y.minimize,
							S = x.element.getDocument().getById(Q._.id);
							S.getChild(1).setHtml(R);
							S.setAttribute('title', R);
							S.setAttribute('href', 'javascript:void("' + R + '");');
						}
						if (x.mode == 'wysiwyg') {
							if (B) {
								g.gecko && v(x);
								x.getSelection().selectRanges(B);
								var T = x.getSelection().getStartElement();
								T && T.scrollIntoView(true);
							} else
								A.$.scrollTo(C.x, C.y);
						} else {
							if (B) {
								K.selectionStart = B[0];
								K.selectionEnd = B[1];
							}
							K.scrollLeft = C[0];
							K.scrollTop = C[1];
						}
						B = C = null;
						G = this.state;
					},
					canUndo : false
				});
				x.ui.addButton('Maximize', {
					label : y.maximize,
					command : 'maximize'
				});
				x.on('mode', function () {
					var H = x.getCommand('maximize');
					H.setState(H.state == 0 ? 0 : G);
				}, null, null, 100);
			}
		});
	})();
	o.add('newpage', {
		init : function (r) {
			r.addCommand('newpage', {
				modes : {
					wysiwyg : 1,
					source : 1
				},
				exec : function (s) {
					var t = this;
					s.setData(s.config.newpage_html || '', function () {
						setTimeout(function () {
							s.fire('afterCommandExec', {
								name : 'newpage',
								command : t
							});
							s.selectionChange();
						}, 200);
					});
					s.focus();
				},
				async : true
			});
			r.ui.addButton('NewPage', {
				label : r.lang.newPage,
				command : 'newpage'
			});
		}
	});
	o.add('pagebreak', {
		init : function (r) {
			r.addCommand('pagebreak', o.pagebreakCmd);
			r.ui.addButton('PageBreak', {
				label : r.lang.pagebreak,
				command : 'pagebreak'
			});
			var s = ['{', 'background: url(' + f.getUrl(this.path + 'images/pagebreak.gif') + ') no-repeat center center;', 'clear: both;', 'width:100%; _width:99.9%;', 'border-top: #999999 1px dotted;', 'border-bottom: #999999 1px dotted;', 'padding:0;', 'height: 5px;', 'cursor: default;', '}'].join('').replace(/;/g, ' !important;');
			r.addCss('div.cke_pagebreak' + s);
			g.opera && r.on('contentDom', function () {
				r.document.on('click', function (t) {
					var u = t.data.getTarget();
					if (u.is('div') && u.hasClass('cke_pagebreak'))
						r.getSelection().selectElement(u);
				});
			});
		},
		afterInit : function (r) {
			var s = r.lang.pagebreakAlt,
			t = r.dataProcessor,
			u = t && t.dataFilter,
			v = t && t.htmlFilter;
			if (v)
				v.addRules({
					attributes : {
						'class' : function (w, x) {
							var y = w.replace('cke_pagebreak', '');
							if (y != w) {
								var z = f.htmlParser.fragment.fromHtml('<span style="display: none;">&nbsp;</span>');
								x.children.length = 0;
								x.add(z);
								var A = x.attributes;
								delete A['aria-label'];
								delete A.contenteditable;
								delete A.title;
							}
							return y;
						}
					}
				}, 5);
			if (u)
				u.addRules({
					elements : {
						div : function (w) {
							var x = w.attributes,
							y = x && x.style,
							z = y && w.children.length == 1 && w.children[0],
							A = z && z.name == 'span' && z.attributes.style;
							if (A && /page-break-after\s*:\s*always/i.test(y) && /display\s*:\s*none/i.test(A)) {
								x.contenteditable = 'false';
								x['class'] = 'cke_pagebreak';
								x['data-cke-display-name'] = 'pagebreak';
								x['aria-label'] = s;
								x.title = s;
								w.children.length = 0;
							}
						}
					}
				});
		},
		requires : ['fakeobjects']
	});
	o.pagebreakCmd = {
		exec : function (r) {
			var s = r.lang.pagebreakAlt,
			t = m.createFromHtml('<div style="page-break-after: always;"contenteditable="false" title="' + s + '" ' + 'aria-label="' + s + '" ' + 'data-cke-display-name="pagebreak" ' + 'class="cke_pagebreak">' + '</div>', r.document),
			u = r.getSelection().getRanges(true);
			r.fire('saveSnapshot');
			for (var v, w = u.length - 1; w >= 0; w--) {
				v = u[w];
				if (w < u.length - 1)
					t = t.clone(true);
				v.splitBlock('p');
				v.insertNode(t);
				if (w == u.length - 1) {
					var x = t.getNext();
					v.moveToPosition(t, 4);
					if (!x || x.type == 1 && !x.isEditable())
						v.fixBlock(true, r.config.enterMode == 3 ? 'div' : 'p');
					v.select();
				}
			}
			r.fire('saveSnapshot');
		}
	};
	(function () {
		function r(s) {
			s.data.mode = 'html';
		};
		o.add('pastefromword', {
			init : function (s) {
				var t = 0,
				u = function (v) {
					v && v.removeListener();
					s.removeListener('beforePaste', r);
					t && setTimeout(function () {
						t = 0;
					}, 0);
				};
				s.addCommand('pastefromword', {
					canUndo : false,
					exec : function () {
						t = 1;
						s.on('beforePaste', r);
						if (s.execCommand('paste', 'html') === false) {
							s.on('dialogShow', function (v) {
								v.removeListener();
								v.data.on('cancel', u);
							});
							s.on('dialogHide', function (v) {
								v.data.removeListener('cancel', u);
							});
						}
						s.on('afterPaste', u);
					}
				});
				s.ui.addButton('PasteFromWord', {
					label : s.lang.pastefromword.toolbar,
					command : 'pastefromword'
				});
				s.on('pasteState', function (v) {
					s.getCommand('pastefromword').setState(v.data);
				});
				s.on('paste', function (v) {
					var w = v.data,
					x;
					if ((x = w.html) && (t || /(class=\"?Mso|style=\"[^\"]*\bmso\-|w:WordDocument)/.test(x))) {
						var y = this.loadFilterRules(function () {
								if (y)
									s.fire('paste', w);
								else if (!s.config.pasteFromWordPromptCleanup || t || confirm(s.lang.pastefromword.confirmCleanup))
									w.html = f.cleanWord(x, s);
							});
						y && v.cancel();
					}
				}, this);
			},
			loadFilterRules : function (s) {
				var t = f.cleanWord;
				if (t)
					s();
				else {
					var u = f.getUrl(n.pasteFromWordCleanupFile || this.path + 'filter/default.js');
					f.scriptLoader.load(u, s, null, true);
				}
				return !t;
			},
			requires : ['clipboard']
		});
	})();
	(function () {
		var r = {
			exec : function (s) {
				var t = j.tryThese(function () {
						var u = window.clipboardData.getData('Text');
						if (!u)
							throw 0;
						return u;
					});
				if (!t) {
					s.openDialog('pastetext');
					return false;
				} else
					s.fire('paste', {
						text : t
					});
				return true;
			}
		};
		o.add('pastetext', {
			init : function (s) {
				var t = 'pastetext',
				u = s.addCommand(t, r);
				s.ui.addButton('PasteText', {
					label : s.lang.pasteText.button,
					command : t
				});
				f.dialog.add(t, f.getUrl(this.path + 'dialogs/pastetext.js'));
				if (s.config.forcePasteAsPlainText) {
					s.on('beforeCommandExec', function (v) {
						var w = v.data.commandData;
						if (v.data.name == 'paste' && w != 'html') {
							s.execCommand('pastetext');
							v.cancel();
						}
					}, null, null, 0);
					s.on('beforePaste', function (v) {
						v.data.mode = 'text';
					});
				}
				s.on('pasteState', function (v) {
					s.getCommand('pastetext').setState(v.data);
				});
			},
			requires : ['clipboard']
		});
	})();
	o.add('popup');
	j.extend(f.editor.prototype, {
		popup : function (r, s, t, u) {
			s = s || '80%';
			t = t || '70%';
			if (typeof s == 'string' && s.length > 1 && s.substr(s.length - 1, 1) == '%')
				s = parseInt(window.screen.width * parseInt(s, 10) / 100, 10);
			if (typeof t == 'string' && t.length > 1 && t.substr(t.length - 1, 1) == '%')
				t = parseInt(window.screen.height * parseInt(t, 10) / 100, 10);
			if (s < 640)
				s = 640;
			if (t < 420)
				t = 420;
			var v = parseInt((window.screen.height - t) / 2, 10),
			w = parseInt((window.screen.width - s) / 2, 10);
			u = (u || 'location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,resizable=yes,scrollbars=yes') + ',width=' + s + ',height=' + t + ',top=' + v + ',left=' + w;
			var x = window.open('', null, u, true);
			if (!x)
				return false;
			try {
				var y = navigator.userAgent.toLowerCase();
				if (y.indexOf(' chrome/') == -1) {
					x.moveTo(w, v);
					x.resizeTo(s, t);
				}
				x.focus();
				x.location.href = r;
			} catch (z) {
				x = window.open(r, null, u, true);
			}
			return true;
		}
	});
	(function () {
		var r,
		s = {
			modes : {
				wysiwyg : 1,
				source : 1
			},
			canUndo : false,
			readOnly : 1,
			exec : function (u) {
				var v,
				w = u.config,
				x = w.baseHref ? '<base href="' + w.baseHref + '"/>' : '',
				y = g.isCustomDomain();
				if (w.fullPage)
					v = u.getData().replace(/<head>/, '$&' + x).replace(/[^>]*(?=<\/title>)/, '$& &mdash; ' + u.lang.preview);
				else {
					var z = '<body ',
					A = u.document && u.document.getBody();
					if (A) {
						if (A.getAttribute('id'))
							z += 'id="' + A.getAttribute('id') + '" ';
						if (A.getAttribute('class'))
							z += 'class="' + A.getAttribute('class') + '" ';
					}
					z += '>';
					v = u.config.docType + '<html dir="' + u.config.contentsLangDirection + '">' + '<head>' + x + '<title>' + u.lang.preview + '</title>' + j.buildStyleHtml(u.config.contentsCss) + '</head>' + z + u.getData() + '</body></html>';
				}
				var B = 640,
				C = 420,
				D = 80;
				try {
					var E = window.screen;
					B = Math.round(E.width * 0.8);
					C = Math.round(E.height * 0.7);
					D = Math.round(E.width * 0.1);
				} catch (I) {}
				
				var F = '';
				if (y) {
					window._cke_htmlToLoad = v;
					F = 'javascript:void( (function(){document.open();document.domain="' + document.domain + '";' + 'document.write( window.opener._cke_htmlToLoad );' + 'document.close();' + 'window.opener._cke_htmlToLoad = null;' + '})() )';
				}
				if (g.gecko) {
					window._cke_htmlToLoad = v;
					F = r + 'preview.html';
				}
				var G = window.open(F, null, 'toolbar=yes,location=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=' + B + ',height=' + C + ',left=' + D);
				if (!y && !g.gecko) {
					var H = G.document;
					H.open();
					H.write(v);
					H.close();
					g.webkit && setTimeout(function () {
						H.body.innerHTML += '';
					}, 0);
				}
			}
		},
		t = 'preview';
		o.add(t, {
			init : function (u) {
				r = this.path;
				u.addCommand(t, s);
				u.ui.addButton('Preview', {
					label : u.lang.preview,
					command : t
				});
			}
		});
	})();
	o.add('print', {
		init : function (r) {
			var s = 'print',
			t = r.addCommand(s, o.print);
			r.ui.addButton('Print', {
				label : r.lang.print,
				command : s
			});
		}
	});
	o.print = {
		exec : function (r) {
			if (g.opera)
				return;
			else if (g.gecko)
				r.window.$.print();
			else
				r.document.$.execCommand('Print');
		},
		canUndo : false,
		readOnly : 1,
		modes : {
			wysiwyg : !g.opera
		}
	};
	o.add('removeformat', {
		requires : ['selection'],
		init : function (r) {
			r.addCommand('removeFormat', o.removeformat.commands.removeformat);
			r.ui.addButton('RemoveFormat', {
				label : r.lang.removeFormat,
				command : 'removeFormat'
			});
			r._.removeFormat = {
				filters : []
			};
		}
	});
	o.removeformat = {
		commands : {
			removeformat : {
				exec : function (r) {
					var s = r._.removeFormatRegex || (r._.removeFormatRegex = new RegExp('^(?:' + r.config.removeFormatTags.replace(/,/g, '|') + ')$', 'i')),
					t = r._.removeAttributes || (r._.removeAttributes = r.config.removeFormatAttributes.split(',')),
					u = o.removeformat.filter,
					v = r.getSelection().getRanges(1),
					w = v.createIterator(),
					x;
					while (x = w.getNextRange()) {
						if (!x.collapsed)
							x.enlarge(1);
						var y = x.createBookmark(),
						z = y.startNode,
						A = y.endNode,
						B,
						C = function (E) {
							var F = new i.elementPath(E),
							G = F.elements;
							for (var H = 1, I; I = G[H]; H++) {
								if (I.equals(F.block) || I.equals(F.blockLimit))
									break;
								if (s.test(I.getName()) && u(r, I))
									E.breakParent(I);
							}
						};
						C(z);
						if (A) {
							C(A);
							B = z.getNextSourceNode(true, 1);
							while (B) {
								if (B.equals(A))
									break;
								var D = B.getNextSourceNode(false, 1);
								if (!(B.getName() == 'img' && B.data('cke-realelement')) && u(r, B))
									if (s.test(B.getName()))
										B.remove(1);
									else {
										B.removeAttributes(t);
										r.fire('removeFormatCleanup', B);
									}
								B = D;
							}
						}
						x.moveToBookmark(y);
					}
					r.getSelection().selectRanges(v);
				}
			}
		},
		filter : function (r, s) {
			var t = r._.removeFormat.filters;
			for (var u = 0; u < t.length; u++) {
				if (t[u](s) === false)
					return false;
			}
			return true;
		}
	};
	f.editor.prototype.addRemoveFormatFilter = function (r) {
		this._.removeFormat.filters.push(r);
	};
	n.removeFormatTags = 'b,big,code,del,dfn,em,font,i,ins,kbd,q,samp,small,span,strike,strong,sub,sup,tt,u,var';
	n.removeFormatAttributes = 'class,style,lang,width,height,align,hspace,valign';
	o.add('resize', {
		init : function (r) {
			var s = r.config,
			t = r.element.getDirection(1);
			!s.resize_dir && (s.resize_dir = 'both');
			s.resize_maxWidth == undefined && (s.resize_maxWidth = 3000);
			s.resize_maxHeight == undefined && (s.resize_maxHeight = 3000);
			s.resize_minWidth == undefined && (s.resize_minWidth = 750);
			s.resize_minHeight == undefined && (s.resize_minHeight = 250);
			if (s.resize_enabled !== false) {
				var u = null,
				v,
				w,
				x = (s.resize_dir == 'both' || s.resize_dir == 'horizontal') && s.resize_minWidth != s.resize_maxWidth,
				y = (s.resize_dir == 'both' || s.resize_dir == 'vertical') && s.resize_minHeight != s.resize_maxHeight;
				function z(C) {
					var D = C.data.$.screenX - v.x,
					E = C.data.$.screenY - v.y,
					F = w.width,
					G = w.height,
					H = F + D * (t == 'rtl' ? -1 : 1),
					I = G + E;
					if (x)
						F = Math.max(s.resize_minWidth, Math.min(H, s.resize_maxWidth));
					if (y)
						G = Math.max(s.resize_minHeight, Math.min(I, s.resize_maxHeight));
					r.resize(x ? F : null, G);
				};
				function A(C) {
					f.document.removeListener('mousemove', z);
					f.document.removeListener('mouseup', A);
					if (r.document) {
						r.document.removeListener('mousemove', z);
						r.document.removeListener('mouseup', A);
					}
				};
				var B = j.addFunction(function (C) {
						if (!u)
							u = r.getResizable();
						w = {
							width : u.$.offsetWidth || 0,
							height : u.$.offsetHeight || 0
						};
						v = {
							x : C.screenX,
							y : C.screenY
						};
						s.resize_minWidth > w.width && (s.resize_minWidth = w.width);
						s.resize_minHeight > w.height && (s.resize_minHeight = w.height);
						f.document.on('mousemove', z);
						f.document.on('mouseup', A);
						if (r.document) {
							r.document.on('mousemove', z);
							r.document.on('mouseup', A);
						}
					});
				r.on('destroy', function () {
					j.removeFunction(B);
				});
				r.on('themeSpace', function (C) {
					if (C.data.space == 'bottom') {
						var D = '';
						if (x && !y)
							D = ' cke_resizer_horizontal';
						if (!x && y)
							D = ' cke_resizer_vertical';
						var E = '<div class="cke_resizer' + D + ' cke_resizer_' + t + '"' + ' title="' + j.htmlEncode(r.lang.resize) + '"' + ' onmousedown="CKEDITOR.tools.callFunction(' + B + ', event)"' + '></div>';
						t == 'ltr' && D == 'ltr' ? C.data.html += E : C.data.html = E + C.data.html;
					}
				}, r, null, 100);
			}
		}
	});
	(function () {
		var r = {
			modes : {
				wysiwyg : 1,
				source : 1
			},
			readOnly : 1,
			exec : function (t) {
				var u = t.element.$.form;
				if (u)
					try {
						u.submit();
					} catch (v) {
						if (u.submit.click)
							u.submit.click();
					}
			}
		},
		s = 'save';
		o.add(s, {
			init : function (t) {
				var u = t.addCommand(s, r);
				u.modes = {
					wysiwyg : !!t.element.$.form
				};
				t.ui.addButton('Save', {
					label : t.lang.save,
					command : s
				});
			}
		});
	})();
	(function () {
		var r = '.%2 p,.%2 div,.%2 pre,.%2 address,.%2 blockquote,.%2 h1,.%2 h2,.%2 h3,.%2 h4,.%2 h5,.%2 h6{background-repeat: no-repeat;background-position: top %3;border: 1px dotted gray;padding-top: 8px;padding-%3: 8px;}.%2 p{%1p.png);}.%2 div{%1div.png);}.%2 pre{%1pre.png);}.%2 address{%1address.png);}.%2 blockquote{%1blockquote.png);}.%2 h1{%1h1.png);}.%2 h2{%1h2.png);}.%2 h3{%1h3.png);}.%2 h4{%1h4.png);}.%2 h5{%1h5.png);}.%2 h6{%1h6.png);}',
		s = /%1/g,
		t = /%2/g,
		u = /%3/g,
		v = {
			readOnly : 1,
			preserveState : true,
			editorFocus : false,
			exec : function (w) {
				this.toggleState();
				this.refresh(w);
			},
			refresh : function (w) {
				if (w.document) {
					var x = this.state == 1 ? 'addClass' : 'removeClass';
					w.document.getBody()[x]('cke_show_blocks');
				}
			}
		};
		o.add('showblocks', {
			requires : ['wysiwygarea'],
			init : function (w) {
				var x = w.addCommand('showblocks', v);
				x.canUndo = false;
				if (w.config.startupOutlineBlocks)
					x.setState(1);
				w.addCss(r.replace(s, 'background-image: url(' + f.getUrl(this.path) + 'images/block_').replace(t, 'cke_show_blocks ').replace(u, w.lang.dir == 'rtl' ? 'right' : 'left'));
				w.ui.addButton('ShowBlocks', {
					label : w.lang.showBlocks,
					command : 'showblocks'
				});
				w.on('mode', function () {
					if (x.state != 0)
						x.refresh(w);
				});
				w.on('contentDom', function () {
					if (x.state != 0)
						x.refresh(w);
				});
			}
		});
	})();
	(function () {
		var r = 'cke_show_border',
		s,
		t = (g.ie6Compat ? ['.%1 table.%2,', '.%1 table.%2 td, .%1 table.%2 th', '{', 'border : #d3d3d3 1px dotted', '}'] : ['.%1 table.%2,', '.%1 table.%2 > tr > td, .%1 table.%2 > tr > th,', '.%1 table.%2 > tbody > tr > td, .%1 table.%2 > tbody > tr > th,', '.%1 table.%2 > thead > tr > td, .%1 table.%2 > thead > tr > th,', '.%1 table.%2 > tfoot > tr > td, .%1 table.%2 > tfoot > tr > th', '{', 'border : #d3d3d3 1px dotted', '}']).join('');
		s = t.replace(/%2/g, r).replace(/%1/g, 'cke_show_borders ');
		var u = {
			preserveState : true,
			editorFocus : false,
			readOnly : 1,
			exec : function (v) {
				this.toggleState();
				this.refresh(v);
			},
			refresh : function (v) {
				if (v.document) {
					var w = this.state == 1 ? 'addClass' : 'removeClass';
					v.document.getBody()[w]('cke_show_borders');
				}
			}
		};
		o.add('showborders', {
			requires : ['wysiwygarea'],
			modes : {
				wysiwyg : 1
			},
			init : function (v) {
				var w = v.addCommand('showborders', u);
				w.canUndo = false;
				if (v.config.startupShowBorders !== false)
					w.setState(1);
				v.addCss(s);
				v.on('mode', function () {
					if (w.state != 0)
						w.refresh(v);
				}, null, null, 100);
				v.on('contentDom', function () {
					if (w.state != 0)
						w.refresh(v);
				});
				v.on('removeFormatCleanup', function (x) {
					var y = x.data;
					if (v.getCommand('showborders').state == 1 && y.is('table') && (!y.hasAttribute('border') || parseInt(y.getAttribute('border'), 10) <= 0))
						y.addClass(r);
				});
			},
			afterInit : function (v) {
				var w = v.dataProcessor,
				x = w && w.dataFilter,
				y = w && w.htmlFilter;
				if (x)
					x.addRules({
						elements : {
							table : function (z) {
								var A = z.attributes,
								B = A['class'],
								C = parseInt(A.border, 10);
								if ((!C || C <= 0) && (!B || B.indexOf(r) == -1))
									A['class'] = (B || '') + ' ' + r;
							}
						}
					});
				if (y)
					y.addRules({
						elements : {
							table : function (z) {
								var A = z.attributes,
								B = A['class'];
								B && (A['class'] = B.replace(r, '').replace(/\s{2}/, ' ').replace(/^\s+|\s+$/, ''));
							}
						}
					});
			}
		});
		f.on('dialogDefinition', function (v) {
			var w = v.data.name;
			if (w == 'table' || w == 'tableProperties') {
				var x = v.data.definition,
				y = x.getContents('info'),
				z = y.get('txtBorder'),
				A = z.commit;
				z.commit = j.override(A, function (D) {
						return function (E, F) {
							D.apply(this, arguments);
							var G = parseInt(this.getValue(), 10);
							F[!G || G <= 0 ? 'addClass' : 'removeClass'](r);
						};
					});
				var B = x.getContents('advanced'),
				C = B && B.get('advCSSClasses');
				if (C) {
					C.setup = j.override(C.setup, function (D) {
							return function () {
								D.apply(this, arguments);
								this.setValue(this.getValue().replace(/cke_show_border/, ''));
							};
						});
					C.commit = j.override(C.commit, function (D) {
							return function (E, F) {
								D.apply(this, arguments);
								if (!parseInt(F.getAttribute('border'), 10))
									F.addClass('cke_show_border');
							};
						});
				}
			}
		});
	})();
	o.add('sourcearea', {
		requires : ['editingblock'],
		init : function (r) {
			var s = o.sourcearea,
			t = f.document.getWindow();
			r.on('editingBlockReady', function () {
				var u,
				v;
				r.addMode('source', {
					load : function (w, x) {
						if (h && g.version < 8)
							w.setStyle('position', 'relative');
						r.textarea = u = new m('textarea');
						u.setAttributes({
							dir : 'ltr',
							tabIndex : g.webkit ? -1 : r.tabIndex,
							role : 'textbox',
							'aria-label' : r.lang.editorTitle.replace('%1', r.name)
						});
						u.addClass('cke_source');
						u.addClass('cke_enable_context_menu');
						r.readOnly && u.setAttribute('readOnly', 'readonly');
						var y = {
							width : g.ie7Compat ? '99%' : '100%',
							height : '100%',
							resize : 'none',
							outline : 'none',
							'text-align' : 'left'
						};
						if (h) {
							v = function () {
								u.hide();
								u.setStyle('height', w.$.clientHeight + 'px');
								u.setStyle('width', w.$.clientWidth + 'px');
								u.show();
							};
							r.on('resize', v);
							t.on('resize', v);
							setTimeout(v, 0);
						}
						w.setHtml('');
						w.append(u);
						u.setStyles(y);
						r.fire('ariaWidget', u);
						u.on('blur', function () {
							r.focusManager.blur();
						});
						u.on('focus', function () {
							r.focusManager.focus();
						});
						r.mayBeDirty = true;
						this.loadData(x);
						var z = r.keystrokeHandler;
						if (z)
							z.attach(u);
						setTimeout(function () {
							r.mode = 'source';
							r.fire('mode', {
								previousMode : r._.previousMode
							});
						}, g.gecko || g.webkit ? 100 : 0);
					},
					loadData : function (w) {
						u.setValue(w);
						r.fire('dataReady');
					},
					getData : function () {
						return u.getValue();
					},
					getSnapshotData : function () {
						return u.getValue();
					},
					unload : function (w) {
						u.clearCustomData();
						r.textarea = u = null;
						if (v) {
							r.removeListener('resize', v);
							t.removeListener('resize', v);
						}
						if (h && g.version < 8)
							w.removeStyle('position');
					},
					focus : function () {
						u.focus();
					}
				});
			});
			r.on('readOnly', function () {
				if (r.mode == 'source')
					if (r.readOnly)
						r.textarea.setAttribute('readOnly', 'readonly');
					else
						r.textarea.removeAttribute('readOnly');
			});
			r.addCommand('source', s.commands.source);
			if (r.ui.addButton)
				r.ui.addButton('Source', {
					label : r.lang.source,
					command : 'source'
				});
			r.on('mode', function () {
				r.getCommand('source').setState(r.mode == 'source' ? 1 : 2);
			});
		}
	});
	o.sourcearea = {
		commands : {
			source : {
				modes : {
					wysiwyg : 1,
					source : 1
				},
				editorFocus : false,
				readOnly : 1,
				exec : function (r) {
					if (r.mode == 'wysiwyg')
						r.fire('saveSnapshot');
					r.getCommand('source').setState(0);
					r.setMode(r.mode == 'source' ? 'wysiwyg' : 'source');
				},
				canUndo : false
			}
		}
	};
	(function () {
		o.add('stylescombo', {
			requires : ['richcombo', 'styles'],
			init : function (s) {
				var t = s.config,
				u = s.lang.stylesCombo,
				v = {},
				w = [],
				x;
				function y(z) {
					s.getStylesSet(function (A) {
						if (!w.length) {
							var B,
							C;
							for (var D = 0, E = A.length; D < E; D++) {
								var F = A[D];
								C = F.name;
								B = v[C] = new f.style(F);
								B._name = C;
								B._.enterMode = t.enterMode;
								w.push(B);
							}
							w.sort(r);
						}
						z && z();
					});
				};
				s.ui.addRichCombo('Styles', {
					label : u.label,
					title : u.panelTitle,
					className : 'cke_styles',
					panel : {
						css : s.skin.editor.css.concat(t.contentsCss),
						multiSelect : true,
						attributes : {
							'aria-label' : u.panelTitle
						}
					},
					init : function () {
						x = this;
						y(function () {
							var z,
							A,
							B,
							C,
							D,
							E;
							for (D = 0, E = w.length; D < E; D++) {
								z = w[D];
								A = z._name;
								C = z.type;
								if (C != B) {
									x.startGroup(u['panelTitle' + String(C)]);
									B = C;
								}
								x.add(A, z.type == 3 ? A : z.buildPreview(), A);
							}
							x.commit();
						});
					},
					onClick : function (z) {
						s.focus();
						s.fire('saveSnapshot');
						var A = v[z],
						B = s.getSelection(),
						C = new i.elementPath(B.getStartElement());
						A[A.checkActive(C) ? 'remove' : 'apply'](s.document);
						s.fire('saveSnapshot');
					},
					onRender : function () {
						s.on('selectionChange', function (z) {
							var A = this.getValue(),
							B = z.data.path,
							C = B.elements;
							for (var D = 0, E = C.length, F; D < E; D++) {
								F = C[D];
								for (var G in v) {
									if (v[G].checkElementRemovable(F, true)) {
										if (G != A)
											this.setValue(G);
										return;
									}
								}
							}
							this.setValue('');
						}, this);
					},
					onOpen : function () {
						var G = this;
						if (h || g.webkit)
							s.focus();
						var z = s.getSelection(),
						A = z.getSelectedElement(),
						B = new i.elementPath(A || z.getStartElement()),
						C = [0, 0, 0, 0];
						G.showAll();
						G.unmarkAll();
						for (var D in v) {
							var E = v[D],
							F = E.type;
							if (E.checkActive(B))
								G.mark(D);
							else if (F == 3 && !E.checkApplicable(B)) {
								G.hideItem(D);
								C[F]--;
							}
							C[F]++;
						}
						if (!C[1])
							G.hideGroup(u['panelTitle' + String(1)]);
						if (!C[2])
							G.hideGroup(u['panelTitle' + String(2)]);
						if (!C[3])
							G.hideGroup(u['panelTitle' + String(3)]);
					},
					reset : function () {
						if (x) {
							delete x._.panel;
							delete x._.list;
							x._.committed = 0;
							x._.items = {};
							x._.state = 2;
						}
						v = {};
						w = [];
						y();
					}
				});
				s.on('instanceReady', function () {
					y();
				});
			}
		});
		function r(s, t) {
			var u = s.type,
			v = t.type;
			return u == v ? 0 : u == 3 ? -1 : v == 3 ? 1 : v == 1 ? 1 : -1;
		};
	})();
	o.add('specialchar', {
		requires : ['dialog'],
		availableLangs : {
			cs : 1,
			cy : 1,
			de : 1,
			el : 1,
			en : 1,
			eo : 1,
			et : 1,
			fa : 1,
			fi : 1,
			fr : 1,
			he : 1,
			hr : 1,
			it : 1,
			nb : 1,
			nl : 1,
			no : 1,
			'pt-br' : 1,
			tr : 1,
			ug : 1,
			'zh-cn' : 1
		},
		init : function (r) {
			var s = 'specialchar',
			t = this;
			f.dialog.add(s, this.path + 'dialogs/specialchar.js');
			r.addCommand(s, {
				exec : function () {
					var u = r.langCode;
					u = t.availableLangs[u] ? u : 'en';
					f.scriptLoader.load(f.getUrl(t.path + 'lang/' + u + '.js'), function () {
						j.extend(r.lang.specialChar, t.langEntries[u]);
						r.openDialog(s);
					});
				},
				modes : {
					wysiwyg : 1
				},
				canUndo : false
			});
			r.ui.addButton('SpecialChar', {
				label : r.lang.specialChar.toolbar,
				command : s
			});
		}
	});
	n.specialChars = ['!', '&quot;', '#', '$', '%', '&amp;', "'", '(', ')', '*', '+', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '&lt;', '=', '&gt;', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', '&euro;', '&lsquo;', '&rsquo;', '&ldquo;', '&rdquo;', '&ndash;', '&mdash;', '&iexcl;', '&cent;', '&pound;', '&curren;', '&yen;', '&brvbar;', '&sect;', '&uml;', '&copy;', '&ordf;', '&laquo;', '&not;', '&reg;', '&macr;', '&deg;', '&sup2;', '&sup3;', '&acute;', '&micro;', '&para;', '&middot;', '&cedil;', '&sup1;', '&ordm;', '&raquo;', '&frac14;', '&frac12;', '&frac34;', '&iquest;', '&Agrave;', '&Aacute;', '&Acirc;', '&Atilde;', '&Auml;', '&Aring;', '&AElig;', '&Ccedil;', '&Egrave;', '&Eacute;', '&Ecirc;', '&Euml;', '&Igrave;', '&Iacute;', '&Icirc;', '&Iuml;', '&ETH;', '&Ntilde;', '&Ograve;', '&Oacute;', '&Ocirc;', '&Otilde;', '&Ouml;', '&times;', '&Oslash;', '&Ugrave;', '&Uacute;', '&Ucirc;', '&Uuml;', '&Yacute;', '&THORN;', '&szlig;', '&agrave;', '&aacute;', '&acirc;', '&atilde;', '&auml;', '&aring;', '&aelig;', '&ccedil;', '&egrave;', '&eacute;', '&ecirc;', '&euml;', '&igrave;', '&iacute;', '&icirc;', '&iuml;', '&eth;', '&ntilde;', '&ograve;', '&oacute;', '&ocirc;', '&otilde;', '&ouml;', '&divide;', '&oslash;', '&ugrave;', '&uacute;', '&ucirc;', '&uuml;', '&yacute;', '&thorn;', '&yuml;', '&OElig;', '&oelig;', '&#372;', '&#374', '&#373', '&#375;', '&sbquo;', '&#8219;', '&bdquo;', '&hellip;', '&trade;', '&#9658;', '&bull;', '&rarr;', '&rArr;', '&hArr;', '&diams;', '&asymp;'];
	(function () {
		var r = {
			editorFocus : false,
			modes : {
				wysiwyg : 1,
				ipssource : 1
			}
		},
		s = {
			readOnly : 1,
			exec : function (v) {
				v.container.focusNext(true, v.tabIndex);
			}
		},
		t = {
			readOnly : 1,
			exec : function (v) {
				v.container.focusPrevious(true, v.tabIndex);
			}
		};
		function u(v) {
			return {
				editorFocus : false,
				canUndo : false,
				modes : {
					wysiwyg : 1
				},
				exec : function (w) {
					if (w.focusManager.hasFocus) {
						var x = w.getSelection(),
						y = x.getCommonAncestor(),
						z;
						if (z = y.getAscendant('td', true) || y.getAscendant('th', true)) {
							var A = new i.range(w.document),
							B = j.tryThese(function () {
									var I = z.getParent(),
									J = I.$.cells[z.$.cellIndex + (v ? -1 : 1)];
									J.parentNode.parentNode;
									return J;
								}, function () {
									var I = z.getParent(),
									J = I.getAscendant('table'),
									K = J.$.rows[I.$.rowIndex + (v ? -1 : 1)];
									return K.cells[v ? K.cells.length - 1 : 0];
								});
							if (!(B || v)) {
								var C = z.getAscendant('table').$,
								D = z.getParent().$.cells,
								E = new m(C.insertRow(-1), w.document);
								for (var F = 0, G = D.length; F < G;
									F++) {
									var H = E.append(new m(D[F], w.document).clone(false, false));
									!h && H.appendBogus();
								}
								A.moveToElementEditStart(E);
							} else if (B) {
								B = new m(B);
								A.moveToElementEditStart(B);
								if (!(A.checkStartOfBlock() && A.checkEndOfBlock()))
									A.selectNodeContents(B);
							} else
								return true;
							A.select(true);
							return true;
						}
					}
					return false;
				}
			};
		};
		o.add('tab', {
			requires : ['keystrokes'],
			init : function (v) {
				var w = v.config.enableTabKeyTools !== false,
				x = v.config.tabSpaces || 0,
				y = '';
				while (x--)
					y += '\xa0';
				if (y)
					v.on('key', function (z) {
						if (z.data.keyCode == 9) {
							v.insertHtml(y);
							z.cancel();
						}
					});
				if (w)
					v.on('key', function (z) {
						if (z.data.keyCode == 9 && v.execCommand('selectNextCell') || z.data.keyCode == 2000 + 9 && v.execCommand('selectPreviousCell'))
							z.cancel();
					});
				if (g.webkit || g.gecko)
					v.on('key', function (z) {
						var A = z.data.keyCode;
						if (A == 9 && !y) {
							z.cancel();
							v.execCommand('blur');
						}
						if (A == 2000 + 9) {
							v.execCommand('blurBack');
							z.cancel();
						}
					});
				v.addCommand('blur', j.extend(s, r));
				v.addCommand('blurBack', j.extend(t, r));
				v.addCommand('selectNextCell', u());
				v.addCommand('selectPreviousCell', u(true));
			}
		});
	})();
	m.prototype.focusNext = function (r, s) {
		var B = this;
		var t = B.$,
		u = s === undefined ? B.getTabIndex() : s,
		v,
		w,
		x,
		y,
		z,
		A;
		if (u <= 0) {
			z = B.getNextSourceNode(r, 1);
			while (z) {
				if (z.isVisible() && z.getTabIndex() === 0) {
					x = z;
					break;
				}
				z = z.getNextSourceNode(false, 1);
			}
		} else {
			z = B.getDocument().getBody().getFirst();
			while (z = z.getNextSourceNode(false, 1)) {
				if (!v)
					if (!w && z.equals(B)) {
						w = true;
						if (r) {
							if (!(z = z.getNextSourceNode(true, 1)))
								break;
							v = 1;
						}
					} else if (w && !B.contains(z))
						v = 1;
				if (!z.isVisible() || (A = z.getTabIndex()) < 0)
					continue;
				if (v && A == u) {
					x = z;
					break;
				}
				if (A > u && (!x || !y || A < y)) {
					x = z;
					y = A;
				} else if (!x && A === 0) {
					x = z;
					y = A;
				}
			}
		}
		if (x)
			x.focus();
	};
	m.prototype.focusPrevious = function (r, s) {
		var B = this;
		var t = B.$,
		u = s === undefined ? B.getTabIndex() : s,
		v,
		w,
		x,
		y = 0,
		z,
		A = B.getDocument().getBody().getLast();
		while (A = A.getPreviousSourceNode(false, 1)) {
			if (!v)
				if (!w && A.equals(B)) {
					w = true;
					if (r) {
						if (!(A = A.getPreviousSourceNode(true, 1)))
							break;
						v = 1;
					}
				} else if (w && !B.contains(A))
					v = 1;
			if (!A.isVisible() || (z = A.getTabIndex()) < 0)
				continue;
			if (u <= 0) {
				if (v && z === 0) {
					x = A;
					break;
				}
				if (z > y) {
					x = A;
					y = z;
				}
			} else {
				if (v && z == u) {
					x = A;
					break;
				}
				if (z < u && (!x || z > y)) {
					x = A;
					y = z;
				}
			}
		}
		if (x)
			x.focus();
	};
	(function () {
		o.add('templates', {
			requires : ['dialog'],
			init : function (t) {
				f.dialog.add('templates', f.getUrl(this.path + 'dialogs/templates.js'));
				t.addCommand('templates', new f.dialogCommand('templates'));
				t.ui.addButton('Templates', {
					label : t.lang.templates.button,
					command : 'templates'
				});
			}
		});
		var r = {},
		s = {};
		f.addTemplates = function (t, u) {
			r[t] = u;
		};
		f.getTemplates = function (t) {
			return r[t];
		};
		f.loadTemplates = function (t, u) {
			var v = [];
			for (var w = 0, x = t.length;
				w < x; w++) {
				if (!s[t[w]]) {
					v.push(t[w]);
					s[t[w]] = 1;
				}
			}
			if (v.length)
				f.scriptLoader.load(v, u);
			else
				setTimeout(u, 0);
		};
	})();
	n.templates_files = [f.getUrl('plugins/templates/templates/default.js')];
	n.templates_replaceContent = true;
	(function () {
		var r = function () {
			this.toolbars = [];
			this.focusCommandExecuted = false;
		};
		r.prototype.focus = function () {
			for (var t = 0, u; u = this.toolbars[t++]; )
				for (var v = 0, w; w = u.items[v++]; ) {
					if (w.focus) {
						w.focus();
						return;
					}
				}
		};
		var s = {
			toolbarFocus : {
				modes : {
					wysiwyg : 1,
					source : 1
				},
				readOnly : 1,
				exec : function (t) {
					if (t.toolbox) {
						t.toolbox.focusCommandExecuted = true;
						if (h || g.air)
							setTimeout(function () {
								t.toolbox.focus();
							}, 100);
						else
							t.toolbox.focus();
					}
				}
			}
		};
		o.add('toolbar', {
			requires : ['button'],
			init : function (t) {
				var u,
				v = function (w, x) {
					var y,
					z,
					A = t.lang.dir == 'rtl',
					B = t.config.toolbarGroupCycling;
					B = B === undefined || B;
					switch (x) {
					case 9:
					case 2000 + 9:
						while (!z || !z.items.length) {
							z = x == 9 ? (z ? z.next : w.toolbar.next) || t.toolbox.toolbars[0] : (z ? z.previous : w.toolbar.previous) || t.toolbox.toolbars[t.toolbox.toolbars.length - 1];
							if (z.items.length) {
								w = z.items[u ? z.items.length - 1 : 0];
								while (w && !w.focus) {
									w = u ? w.previous : w.next;
									if (!w)
										z = 0;
								}
							}
						}
						if (w)
							w.focus();
						return false;
					case A ? 37:
						39 : case 40:
						y = w;
						do {
							y = y.next;
							if (!y && B)
								y = w.toolbar.items[0];
						} while (y && !y.focus)
						if (y)
							y.focus();
						else
							v(w, 9);
						return false;
					case A ? 39:
						37 : case 38:
						y = w;
						do {
							y = y.previous;
							if (!y && B)
								y = w.toolbar.items[w.toolbar.items.length - 1];
						} while (y && !y.focus)
						if (y)
							y.focus();
						else {
							u = 1;
							v(w, 2000 + 9);
							u = 0;
						}
						return false;
					case 27:
						t.focus();
						return false;
					case 13:
					case 32:
						w.execute();
						return false;
					}
					return true;
				};
				t.on('themeSpace', function (w) {
					if (w.data.space == t.config.toolbarLocation) {
						t.toolbox = new r();
						var x = j.getNextId(),
						y = ['<div class="cke_toolbox" role="group" aria-labelledby="', x, '" onmousedown="return false;"'],
						z = t.config.toolbarStartupExpanded !== false,
						A;
						y.push(z ? '>' : ' style="display:none">');
						y.push('<span id="', x, '" class="cke_voice_label">', t.lang.toolbars, '</span>');
						var B = t.toolbox.toolbars,
						C = t.config.toolbar instanceof Array ? t.config.toolbar : t.config['toolbar_' + t.config.toolbar];
						for (var D = 0; D < C.length; D++) {
							var E,
							F = 0,
							G,
							H = C[D],
							I;
							if (!H)
								continue;
							if (A) {
								y.push('</div>');
								A = 0;
							}
							if (H === '/') {
								y.push('<div class="cke_break"></div>');
								continue;
							}
							I = H.items || H;
							for (var J = 0; J < I.length; J++) {
								var K,
								L = I[J],
								M;
								K = t.ui.create(L);
								if (K) {
									M = K.canGroup !== false;
									if (!F) {
										E = j.getNextId();
										F = {
											id : E,
											items : []
										};
										G = H.name && (t.lang.toolbarGroups[H.name] || H.name);
										y.push('<span id="', E, '" class="cke_toolbar"', G ? ' aria-labelledby="' + E + '_label"' : '', ' role="toolbar">');
										G && y.push('<span id="', E, '_label" class="cke_voice_label">', G, '</span>');
										y.push('<span class="cke_toolbar_start"></span>');
										var N = B.push(F) - 1;
										if (N > 0) {
											F.previous = B[N - 1];
											F.previous.next = F;
										}
									}
									if (M) {
										if (!A) {
											y.push('<span class="cke_toolgroup" role="presentation">');
											A = 1;
										}
									} else if (A) {
										y.push('</span>');
										A = 0;
									}
									var O = K.render(t, y);
									N = F.items.push(O) - 1;
									if (N > 0) {
										O.previous = F.items[N - 1];
										O.previous.next = O;
									}
									O.toolbar = F;
									O.onkey = v;
									O.onfocus = function () {
										if (!t.toolbox.focusCommandExecuted)
											t.focus();
									};
								}
							}
							if (A) {
								y.push('</span>');
								A = 0;
							}
							if (F)
								y.push('<span class="cke_toolbar_end"></span></span>');
						}
						y.push('</div>');
						if (t.config.toolbarCanCollapse) {
							var P = j.addFunction(function () {
									t.execCommand('toolbarCollapse');
								});
							t.on('destroy', function () {
								j.removeFunction(P);
							});
							var Q = j.getNextId();
							t.addCommand('toolbarCollapse', {
								readOnly : 1,
								exec : function (R) {
									var S = f.document.getById(Q),
									T = S.getPrevious(),
									U = R.getThemeSpace('contents'),
									V = T.getParent(),
									W = parseInt(U.$.style.height, 10),
									X = V.$.offsetHeight,
									Y = !T.isVisible();
									if (!Y) {
										T.hide();
										S.addClass('cke_toolbox_collapser_min');
										S.setAttribute('title', R.lang.toolbarExpand);
									} else {
										T.show();
										S.removeClass('cke_toolbox_collapser_min');
										S.setAttribute('title', R.lang.toolbarCollapse);
									}
									S.getFirst().setText(Y ? '▲' : '◀');
									var Z = V.$.offsetHeight - X;
									U.setStyle('height', W - Z + 'px');
									R.fire('resize');
								},
								modes : {
									wysiwyg : 1,
									source : 1
								}
							});
							y.push('<a title="' + (z ? t.lang.toolbarCollapse : t.lang.toolbarExpand) + '" id="' + Q + '" tabIndex="-1" class="cke_toolbox_collapser');
							if (!z)
								y.push(' cke_toolbox_collapser_min');
							y.push('" onclick="CKEDITOR.tools.callFunction(' + P + ')">', '<span>&#9650;</span>', '</a>');
						}
						w.data.html += y.join('');
					}
				});
				t.on('destroy', function () {
					var w,
					x = 0,
					y,
					z,
					A;
					w = this.toolbox.toolbars;
					for (; x < w.length; x++) {
						z = w[x].items;
						for (y = 0; y < z.length; y++) {
							A = z[y];
							if (A.clickFn)
								j.removeFunction(A.clickFn);
							if (A.keyDownFn)
								j.removeFunction(A.keyDownFn);
						}
					}
				});
				t.addCommand('toolbarFocus', s.toolbarFocus);
				t.ui.add('-', f.UI_SEPARATOR, {});
				t.ui.addHandler(f.UI_SEPARATOR, {
					create : function () {
						return {
							render : function (w, x) {
								x.push('<span class="cke_separator" role="separator"></span>');
								return {};
							}
						};
					}
				});
			}
		});
	})();
	f.UI_SEPARATOR = 'separator';
	n.toolbarLocation = 'top';
	n.toolbar_Basic = [['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink', '-', 'About']];
	n.toolbar_Full = [{
			name : 'document',
			items : ['Source', '-', 'Save', 'NewPage', 'DocProps', 'Preview', 'Print', '-', 'Templates']
		}, {
			name : 'clipboard',
			items : ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo']
		}, {
			name : 'editing',
			items : ['Find', 'Replace', '-', 'SelectAll', '-', 'SpellChecker', 'Scayt']
		}, {
			name : 'forms',
			items : ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField']
		}, '/', {
			name : 'basicstyles',
			items : ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat']
		}, {
			name : 'paragraph',
			items : ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl']
		}, {
			name : 'links',
			items : ['Link', 'Unlink', 'Anchor']
		}, {
			name : 'insert',
			items : ['Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak', 'Iframe']
		}, '/', {
			name : 'styles',
			items : ['Styles', 'Format', 'Font', 'FontSize']
		}, {
			name : 'colors',
			items : ['TextColor', 'BGColor']
		}, {
			name : 'tools',
			items : ['Maximize', 'ShowBlocks', '-', 'About']
		}
	];
	n.toolbar = 'Full';
	n.toolbarCanCollapse = true;
	(function () {
		o.add('undo', {
			requires : ['selection', 'wysiwygarea'],
			init : function (x) {
				var y = new t(x),
				z = x.addCommand('undo', {
						exec : function () {
							if (y.undo()) {
								x.selectionChange();
								this.fire('afterUndo');
							}
						},
						state : 0,
						canUndo : false
					}),
				A = x.addCommand('redo', {
						exec : function () {
							if (y.redo()) {
								x.selectionChange();
								this.fire('afterRedo');
							}
						},
						state : 0,
						canUndo : false
					});
				y.onChange = function () {
					z.setState(y.undoable() ? 2 : 0);
					A.setState(y.redoable() ? 2 : 0);
				};
				function B(C) {
					if (y.enabled && C.data.command.canUndo !== false)
						y.save();
				};
				x.on('beforeCommandExec', B);
				x.on('afterCommandExec', B);
				x.on('saveSnapshot', function (C) {
					y.save(C.data && C.data.contentOnly);
				});
				x.on('contentDom', function () {
					x.document.on('keydown', function (C) {
						if (!C.data.$.ctrlKey && !C.data.$.metaKey)
							y.type(C);
					});
				});
				x.on('beforeModeUnload', function () {
					x.mode == 'wysiwyg' && y.save(true);
				});
				x.on('mode', function () {
					y.enabled = x.readOnly ? false : x.mode == 'wysiwyg';
					y.onChange();
				});
				x.ui.addButton('Undo', {
					label : x.lang.undo,
					command : 'undo'
				});
				x.ui.addButton('Redo', {
					label : x.lang.redo,
					command : 'redo'
				});
				x.resetUndo = function () {
					y.reset();
					x.fire('saveSnapshot');
				};
				x.on('updateSnapshot', function () {
					if (y.currentImage)
						y.update();
				});
			}
		});
		o.undo = {};
		var r = o.undo.Image = function (x) {
			this.editor = x;
			x.fire('beforeUndoImage');
			var y = x.getSnapshot(),
			z = y && x.getSelection();
			h && y && (y = y.replace(/\s+data-cke-expando=".*?"/g, ''));
			this.contents = y;
			this.bookmarks = z && z.createBookmarks2(true);
			x.fire('afterUndoImage');
		},
		s = /\b(?:href|src|name)="[^"]*?"/gi;
		r.prototype = {
			equals : function (x, y) {
				var z = this.contents,
				A = x.contents;
				if (h && (g.ie7Compat || g.ie6Compat)) {
					z = z.replace(s, '');
					A = A.replace(s, '');
				}
				if (z != A)
					return false;
				if (y)
					return true;
				var B = this.bookmarks,
				C = x.bookmarks;
				if (B || C) {
					if (!B || !C || B.length != C.length)
						return false;
					for (var D = 0; D < B.length; D++) {
						var E = B[D],
						F = C[D];
						if (E.startOffset != F.startOffset || E.endOffset != F.endOffset || !j.arrayCompare(E.start, F.start) || !j.arrayCompare(E.end, F.end))
							return false;
					}
				}
				return true;
			}
		};
		function t(x) {
			this.editor = x;
			this.reset();
		};
		var u = {
			8 : 1,
			46 : 1
		},
		v = {
			16 : 1,
			17 : 1,
			18 : 1
		},
		w = {
			37 : 1,
			38 : 1,
			39 : 1,
			40 : 1
		};
		t.prototype = {
			type : function (x) {
				var y = x && x.data.getKey(),
				z = y in v,
				A = y in u,
				B = this.lastKeystroke in u,
				C = A && y == this.lastKeystroke,
				D = y in w,
				E = this.lastKeystroke in w,
				F = !A && !D,
				G = A && !C,
				H = !(z || this.typing) || F && (B || E);
				if (H || G) {
					var I = new r(this.editor),
					J = this.snapshots.length;
					j.setTimeout(function () {
						var L = this;
						var K = L.editor.getSnapshot();
						if (h)
							K = K.replace(/\s+data-cke-expando=".*?"/g, '');
						if (I.contents != K && J == L.snapshots.length) {
							L.typing = true;
							if (!L.save(false, I, false))
								L.snapshots.splice(L.index + 1, L.snapshots.length - L.index - 1);
							L.hasUndo = true;
							L.hasRedo = false;
							L.typesCount = 1;
							L.modifiersCount = 1;
							L.onChange();
						}
					}, 0, this);
				}
				this.lastKeystroke = y;
				if (A) {
					this.typesCount = 0;
					this.modifiersCount++;
					if (this.modifiersCount > 25) {
						this.save(false, null, false);
						this.modifiersCount = 1;
					}
				} else if (!D) {
					this.modifiersCount = 0;
					this.typesCount++;
					if (this.typesCount > 25) {
						this.save(false, null, false);
						this.typesCount = 1;
					}
				}
			},
			reset : function () {
				var x = this;
				x.lastKeystroke = 0;
				x.snapshots = [];
				x.index = -1;
				x.limit = x.editor.config.undoStackSize || 20;
				x.currentImage = null;
				x.hasUndo = false;
				x.hasRedo = false;
				x.resetType();
			},
			resetType : function () {
				var x = this;
				x.typing = false;
				delete x.lastKeystroke;
				x.typesCount = 0;
				x.modifiersCount = 0;
			},
			fireChange : function () {
				var x = this;
				x.hasUndo = !!x.getNextImage(true);
				x.hasRedo = !!x.getNextImage(false);
				x.resetType();
				x.onChange();
			},
			save : function (x, y, z) {
				var B = this;
				var A = B.snapshots;
				if (!y)
					y = new r(B.editor);
				if (y.contents === false)
					return false;
				if (B.currentImage && y.equals(B.currentImage, x))
					return false;
				A.splice(B.index + 1, A.length - B.index - 1);
				if (A.length == B.limit)
					A.shift();
				B.index = A.push(y) - 1;
				B.currentImage = y;
				if (z !== false)
					B.fireChange();
				return true;
			},
			restoreImage : function (x) {
				var B = this;
				var y = B.editor,
				z;
				if (x.bookmarks) {
					y.focus();
					z = y.getSelection();
				}
				B.editor.loadSnapshot(x.contents);
				if (x.bookmarks)
					z.selectBookmarks(x.bookmarks);
				else if (h) {
					var A = B.editor.document.getBody().$.createTextRange();
					A.collapse(true);
					A.select();
				}
				B.index = x.index;
				B.update();
				B.fireChange();
			},
			getNextImage : function (x) {
				var C = this;
				var y = C.snapshots,
				z = C.currentImage,
				A,
				B;
				if (z)
					if (x)
						for (B = C.index - 1; B >= 0; B--) {
							A = y[B];
							if (!z.equals(A, true)) {
								A.index = B;
								return A;
							}
						}
					else
						for (B = C.index + 1; B < y.length; B++) {
							A = y[B];
							if (!z.equals(A, true)) {
								A.index = B;
								return A;
							}
						}
				return null;
			},
			redoable : function () {
				return this.enabled && this.hasRedo;
			},
			undoable : function () {
				return this.enabled && this.hasUndo;
			},
			undo : function () {
				var y = this;
				if (y.undoable()) {
					y.save(true);
					var x = y.getNextImage(true);
					if (x)
						return y.restoreImage(x), true;
				}
				return false;
			},
			redo : function () {
				var y = this;
				if (y.redoable()) {
					y.save(true);
					if (y.redoable()) {
						var x = y.getNextImage(false);
						if (x)
							return y.restoreImage(x), true;
					}
				}
				return false;
			},
			update : function () {
				var x = this;
				x.snapshots.splice(x.index, 1, x.currentImage = new r(x.editor));
			}
		};
	})();
	(function () {
		var r = /(^|<body\b[^>]*>)\s*<(p|div|address|h\d|center|pre)[^>]*>\s*(?:<br[^>]*>|&nbsp;|\u00A0|&#160;)?\s*(:?<\/\2>)?\s*(?=$|<\/body>)/gi,
		s = i.walker.whitespaces(true),
		t = i.walker.bogus(true),
		u = function (J) {
			return s(J) && t(J);
		};
		function v(J) {
			return J.isBlockBoundary() && k.$empty[J.getName()];
		};
		function w(J) {
			return function (K) {
				if (this.mode == 'wysiwyg') {
					this.focus();
					var L = this.getSelection(),
					M = L.isLocked;
					M && L.unlock();
					this.fire('saveSnapshot');
					J.call(this, K.data);
					M && this.getSelection().lock();
					var N = this;
					setTimeout(function () {
						try {
							N.fire('saveSnapshot');
						} catch (O) {
							setTimeout(function () {
								N.fire('saveSnapshot');
							}, 200);
						}
					}, 0);
				}
			};
		};
		function x(J) {
			var S = this;
			if (S.dataProcessor)
				J = S.dataProcessor.toHtml(J);
			if (!J)
				return;
			var K = S.getSelection(),
			L = K.getRanges()[0];
			if (L.checkReadOnly())
				return;
			if (g.opera) {
				var M = new i.elementPath(L.startContainer);
				if (M.block) {
					var N = f.htmlParser.fragment.fromHtml(J, false).children;
					for (var O = 0, P = N.length; O < P; O++) {
						if (N[O]._.isBlockLike) {
							L.splitBlock(S.enterMode == 3 ? 'div' : 'p');
							L.insertNode(L.document.createText(''));
							L.select();
							break;
						}
					}
				}
			}
			if (h) {
				var Q = K.getNative();
				if (Q.type == 'Control')
					Q.clear();
				else if (K.getType() == 2) {
					L = K.getRanges()[0];
					var R = L && L.endContainer;
					if (R && R.type == 1 && R.getAttribute('contenteditable') == 'false' && L.checkBoundaryOfElement(R, 2)) {
						L.setEndAfter(L.endContainer);
						L.deleteContents();
					}
				}
				Q.createRange().pasteHTML(J);
			} else
				S.document.$.execCommand('inserthtml', false, J);
			if (g.webkit) {
				K = S.getSelection();
				K.scrollIntoView();
			}
		};
		function y(J) {
			var K = this.getSelection(),
			L = K.getStartElement().hasAscendant('pre', true) ? 2 : this.config.enterMode,
			M = L == 2,
			N = j.htmlEncode(J.replace(/\r\n|\r/g, '\n'));
			N = N.replace(/^[ \t]+|[ \t]+$/g, function (T, U, V) {
					if (T.length == 1)
						return '&nbsp;';
					else if (!U)
						return j.repeat('&nbsp;', T.length - 1) + ' ';
					else
						return ' ' + j.repeat('&nbsp;', T.length - 1);
				});
			N = N.replace(/[ \t]{2,}/g, function (T) {
					return j.repeat('&nbsp;', T.length - 1) + ' ';
				});
			var O = L == 1 ? 'p' : 'div';
			if (!M)
				N = N.replace(/(\n{2})([\s\S]*?)(?:$|\1)/g, function (T, U, V) {
						return '<' + O + '>' + V + '</' + O + '>';
					});
			N = N.replace(/\n/g, '<br>');
			if (!(M || h))
				N = N.replace(new RegExp('<br>(?=</' + O + '>)'), function (T) {
						return j.repeat(T, 2);
					});
			if (g.gecko || g.webkit) {
				var P = new i.elementPath(K.getStartElement()),
				Q = [];
				for (var R = 0; R < P.elements.length; R++) {
					var S = P.elements[R].getName();
					if (S in k.$inline)
						Q.unshift(P.elements[R].getOuterHtml().match(/^<.*?>/));
					else if (S in k.$block)
						break;
				}
				N = Q.join('') + N;
			}
			x.call(this, N);
		};
		function z(J) {
			var K = this.getSelection(),
			L = K.getRanges(),
			M = J.getName(),
			N = k.$block[M],
			O = K.isLocked;
			if (O)
				K.unlock();
			var P,
			Q,
			R,
			S;
			for (var T = L.length - 1; T >= 0; T--) {
				P = L[T];
				if (!P.checkReadOnly()) {
					P.deleteContents(1);
					Q = !T && J || J.clone(1);
					var U,
					V;
					if (N)
						while ((U = P.getCommonAncestor(0, 1)) && (V = k[U.getName()]) && !(V && V[M])) {
							if (U.getName()in k.span)
								P.splitElement(U);
							else if (P.checkStartOfBlock() && P.checkEndOfBlock()) {
								P.setStartBefore(U);
								P.collapse(true);
								U.remove();
							} else
								P.splitBlock();
						}
					P.insertNode(Q);
					if (!R)
						R = Q;
				}
			}
			if (R) {
				P.moveToPosition(R, 4);
				if (N) {
					var W = R.getNext(u),
					X = W && W.type == 1 && W.getName();
					if (X && k.$block[X]) {
						if (k[X]['#'])
							P.moveToElementEditStart(W);
						else
							P.moveToElementEditEnd(R);
					} else if (!W) {
						W = P.fixBlock(true, this.config.enterMode == 3 ? 'div' : 'p');
						P.moveToElementEditStart(W);
					}
				}
			}
			K.selectRanges([P]);
			if (O)
				this.getSelection().lock();
		};
		function A(J) {
			if (!J.checkDirty())
				setTimeout(function () {
					J.resetDirty();
				}, 0);
		};
		var B = i.walker.whitespaces(true),
		C = i.walker.bookmark(false, true);
		function D(J) {
			return B(J) && C(J);
		};
		function E(J) {
			return J.type == 3 && j.trim(J.getText()).match(/^(?:&nbsp;|\xa0)$/);
		};
		function F(J) {
			if (J.isLocked) {
				J.unlock();
				setTimeout(function () {
					J.lock();
				}, 0);
			}
		};
		function G(J) {
			return J.getOuterHtml().match(r);
		};
		B = i.walker.whitespaces(true);
		function H(J) {
			var K = J.window,
			L = J.document,
			M = J.document.getBody(),
			N = M.getFirst(),
			O = M.getChildren().count();
			if (!O || O == 1 && N.type == 1 && N.hasAttribute('_moz_editor_bogus_node')) {
				A(J);
				var P = J.element.getDocument(),
				Q = P.getDocumentElement(),
				R = Q.$.scrollTop,
				S = Q.$.scrollLeft,
				T = L.$.createEvent('KeyEvents');
				T.initKeyEvent('keypress', true, true, K.$, false, false, false, false, 0, 32);
				L.$.dispatchEvent(T);
				if (R != Q.$.scrollTop || S != Q.$.scrollLeft)
					P.getWindow().$.scrollTo(S, R);
				O && M.getFirst().remove();
				L.getBody().appendBogus();
				var U = new i.range(L);
				U.setStartAt(M, 1);
				U.select();
			}
		};
		function I(J) {
			var K = J.editor,
			L = J.data.path,
			M = L.blockLimit,
			N = J.data.selection,
			O = N.getRanges()[0],
			P = K.document.getBody(),
			Q = K.config.enterMode;
			if (g.gecko) {
				var R = L.block || L.blockLimit,
				S = R && R.getLast(D);
				if (R && R.isBlockBoundary() && !(S && S.type == 1 && S.isBlockBoundary()) && !R.is('pre') && !R.getBogus())
					R.appendBogus();
			}
			if (K.config.autoParagraph !== false && Q != 2 && O.collapsed && M.getName() == 'body' && !L.block) {
				var T = O.fixBlock(true, K.config.enterMode == 3 ? 'div' : 'p');
				if (h) {
					var U = T.getFirst(D);
					U && E(U) && U.remove();
				}
				if (G(T)) {
					var V = T.getNext(B);
					if (V && V.type == 1 && !v(V)) {
						O.moveToElementEditStart(V);
						T.remove();
					} else {
						V = T.getPrevious(B);
						if (V && V.type == 1 && !v(V)) {
							O.moveToElementEditEnd(V);
							T.remove();
						}
					}
				}
				O.select();
				J.cancel();
			}
			var W = new i.range(K.document);
			W.moveToElementEditEnd(K.document.getBody());
			var X = new i.elementPath(W.startContainer);
			if (!X.blockLimit.is('body')) {
				var Y;
				if (Q != 2)
					Y = P.append(K.document.createElement(Q == 1 ? 'p' : 'div'));
				else
					Y = P;
				if (!h)
					Y.appendBogus();
			}
		};
		o.add('wysiwygarea', {
			requires : ['editingblock'],
			init : function (J) {
				var K = J.config.enterMode != 2 && J.config.autoParagraph !== false ? J.config.enterMode == 3 ? 'div' : 'p' : false,
				L = J.lang.editorTitle.replace('%1', J.name),
				M = J.lang.editorHelp;
				if (h)
					L += ', ' + M;
				var N = f.document.getWindow(),
				O;
				J.on('editingBlockReady', function () {
					var R,
					S,
					T,
					U,
					V,
					W,
					X,
					Y = g.isCustomDomain(),
					Z = function (ac) {
						if (S)
							S.remove();
						var ad = 'document.open();' + (Y ? 'document.domain="' + document.domain + '";' : '') + 'document.close();';
						ad = g.air ? 'javascript:void(0)' : h ? 'javascript:void(function(){' + encodeURIComponent(ad) + '}())' : '';
						var ae = j.getNextId();
						S = m.createFromHtml('<iframe style="width:100%;height:100%" frameBorder="0" aria-describedby="' + ae + '"' + ' title="' + L + '"' + ' src="' + ad + '"' + ' tabIndex="' + (g.webkit ? -1 : J.tabIndex) + '"' + ' allowTransparency="true"' + '></iframe>');
						if (document.location.protocol == 'chrome:')
							f.event.useCapture = true;
						S.on('load', function (af) {
							V = 1;
							af.removeListener();
							var ag = S.getFrameDocument();
							ag.write(ac);
							g.air && ab(ag.getWindow().$);
						});
						if (document.location.protocol == 'chrome:')
							f.event.useCapture = false;
						R.append(m.createFromHtml('<span id="' + ae + '" class="cke_voice_label">' + M + '</span>'));
						R.append(S);
						if (g.webkit) {
							X = function () {
								R.setStyle('width', '100%');
								S.hide();
								S.setSize('width', R.getSize('width'));
								R.removeStyle('width');
								S.show();
							};
							N.on('resize', X);
						}
					};
					O = j.addFunction(ab);
					var aa = '<script id="cke_actscrpt" type="text/javascript" data-cke-temp="1">' + (Y ? 'document.domain="' + document.domain + '";' : '') + 'window.parent.CKEDITOR.tools.callFunction( ' + O + ', window );' + '</script>';
					function ab(ac) {
						if (!V)
							return;
						V = 0;
						J.fire('ariaWidget', S);
						var ad = ac.document,
						ae = ad.body,
						af = ad.getElementById('cke_actscrpt');
						af && af.parentNode.removeChild(af);
						ae.spellcheck = !J.config.disableNativeSpellChecker;
						var ag = !J.readOnly;
						if (h) {
							ae.hideFocus = true;
							ae.disabled = true;
							ae.contentEditable = ag;
							ae.removeAttribute('disabled');
						} else
							setTimeout(function () {
								if (g.gecko && g.version >= 10900 || g.opera)
									ad.$.body.contentEditable = ag;
								else if (g.webkit)
									ad.$.body.parentNode.contentEditable = ag;
								else
									ad.$.designMode = ag ? 'off' : 'on';
							}, 0);
						ag && g.gecko && j.setTimeout(H, 0, null, J);
						ac = J.window = new i.window(ac);
						ad = J.document = new l(ad);
						ag && ad.on('dblclick', function (al) {
							var am = al.data.getTarget(),
							an = {
								element : am,
								dialog : ''
							};
							J.fire('doubleclick', an);
							an.dialog && J.openDialog(an.dialog);
						});
						h && ad.on('click', function (al) {
							var am = al.data.getTarget();
							if (am.is('input')) {
								var an = am.getAttribute('type');
								if (an == 'submit' || an == 'reset')
									al.data.preventDefault();
							}
						});
						if (!(h || g.opera))
							ad.on('mousedown', function (al) {
								var am = al.data.getTarget();
								if (am.is('img', 'hr', 'input', 'textarea', 'select'))
									J.getSelection().selectElement(am);
							});
						if (g.gecko)
							ad.on('mouseup', function (al) {
								if (al.data.$.button == 2) {
									var am = al.data.getTarget();
									if (!am.getOuterHtml().replace(r, '')) {
										var an = new i.range(ad);
										an.moveToElementEditStart(am);
										an.select(true);
									}
								}
							});
						ad.on('click', function (al) {
							al = al.data;
							if (al.getTarget().is('a') && al.$.button != 2)
								al.preventDefault();
						});
						if (g.webkit) {
							ad.on('mousedown', function () {
								ai = 1;
							});
							ad.on('click', function (al) {
								if (al.data.getTarget().is('input', 'select'))
									al.data.preventDefault();
							});
							ad.on('mouseup', function (al) {
								if (al.data.getTarget().is('input', 'textarea'))
									al.data.preventDefault();
							});
						}
						var ah = h ? S : ac;
						ah.on('blur', function () {
							J.focusManager.blur();
						});
						var ai;
						ah.on('focus', function () {
							var al = J.document;
							if (g.gecko || g.opera)
								al.getBody().focus();
							else if (g.webkit)
								if (!ai) {
									J.document.getDocumentElement().focus();
									ai = 1;
								}
							J.focusManager.focus();
						});
						var aj = J.keystrokeHandler;
						aj.blockedKeystrokes[8] = !ag;
						aj.attach(ad);
						ad.getDocumentElement().addClass(ad.$.compatMode);
						J.on('key', function (al) {
							if (J.mode != 'wysiwyg')
								return;
							var am = al.data.keyCode;
							if (am in {
								8 : 1,
								46 : 1
							}) {
								var an = J.getSelection(),
								ao = an.getSelectedElement(),
								ap = an.getRanges()[0],
								aq = new i.elementPath(ap.startContainer),
								ar,
								as,
								at,
								au = am == 8;
								if (ao) {
									J.fire('saveSnapshot');
									ap.moveToPosition(ao, 3);
									ao.remove();
									ap.select();
									J.fire('saveSnapshot');
									al.cancel();
								} else if (ap.collapsed)
									if ((ar = aq.block) && ap[au ? 'checkStartOfBlock' : 'checkEndOfBlock']() && (at = ar[au ? 'getPrevious' : 'getNext'](s)) && at.is('table')) {
										J.fire('saveSnapshot');
										if (ap[au ? 'checkEndOfBlock' : 'checkStartOfBlock']())
											ar.remove();
										ap['moveToElementEdit' + (au ? 'End' : 'Start')](at);
										ap.select();
										J.fire('saveSnapshot');
										al.cancel();
									} else if (aq.blockLimit.is('td') && (as = aq.blockLimit.getAscendant('table')) && ap.checkBoundaryOfElement(as, au ? 1 : 2) && (at = as[au ? 'getPrevious' : 'getNext'](s))) {
										J.fire('saveSnapshot');
										ap['moveToElementEdit' + (au ? 'End' : 'Start')](at);
										if (ap.checkStartOfBlock() && ap.checkEndOfBlock())
											at.remove();
										else
											ap.select();
										J.fire('saveSnapshot');
										al.cancel();
									}
							}
							if (am == 33 || am == 34)
								if (g.gecko) {
									var av = ad.getBody();
									if (ac.$.innerHeight > av.$.offsetHeight) {
										ap = new i.range(ad);
										ap[am == 33 ? 'moveToElementEditStart' : 'moveToElementEditEnd'](av);
										ap.select();
										al.cancel();
									}
								}
						});
						if (h && ad.$.compatMode == 'CSS1Compat') {
							var ak = {
								33 : 1,
								34 : 1
							};
							ad.on('keydown', function (al) {
								if (al.data.getKeystroke()in ak)
									setTimeout(function () {
										J.getSelection().scrollIntoView();
									}, 0);
							});
						}
						if (h && J.config.enterMode != 1)
							ad.on('selectionchange', function () {
								var al = ad.getBody(),
								am = J.getSelection(),
								an = am && am.getRanges()[0];
								if (an && al.getHtml().match(/^<p>&nbsp;<\/p>$/i) && an.startContainer.equals(al))
									setTimeout(function () {
										an = J.getSelection().getRanges()[0];
										if (!an.startContainer.equals('body')) {
											al.getFirst().remove(1);
											an.moveToElementEditEnd(al);
											an.select(1);
										}
									}, 0);
							});
						if (J.contextMenu)
							J.contextMenu.addTarget(ad, J.config.browserContextMenuOnCtrl !== false);
						setTimeout(function () {
							J.fire('contentDom');
							if (W) {
								J.mode = 'wysiwyg';
								J.fire('mode', {
									previousMode : J._.previousMode
								});
								W = false;
							}
							T = false;
							if (U) {
								J.focus();
								U = false;
							}
							setTimeout(function () {
								J.fire('dataReady');
							}, 0);
							try {
								J.document.$.execCommand('2D-position', false, true);
							} catch (al) {}
							
							try {
								J.document.$.execCommand('enableInlineTableEditing', false, !J.config.disableNativeTableHandles);
							} catch (am) {}
							
							if (J.config.disableObjectResizing)
								try {
									J.document.$.execCommand('enableObjectResizing', false, false);
								} catch (an) {
									J.document.getBody().on(h ? 'resizestart' : 'resize', function (ao) {
										ao.data.preventDefault();
									});
								}
							if (h)
								setTimeout(function () {
									if (J.document) {
										var ao = J.document.$.body;
										ao.runtimeStyle.marginBottom = '0px';
										ao.runtimeStyle.marginBottom = '';
									}
								}, 1000);
						}, 0);
					};
					J.addMode('wysiwyg', {
						load : function (ac, ad, ae) {
							R = ac;
							if (h && g.quirks)
								ac.setStyle('position', 'relative');
							J.mayBeDirty = true;
							W = true;
							if (ae)
								this.loadSnapshotData(ad);
							else
								this.loadData(ad);
						},
						loadData : function (ac) {
							T = true;
							J._.dataStore = {
								id : 1
							};
							var ad = J.config,
							ae = ad.fullPage,
							af = ad.docType,
							ag = '<style type="text/css" data-cke-temp="1">' + J._.styles.join('\n') + '</style>';
							!ae && (ag = j.buildStyleHtml(J.config.contentsCss) + ag);
							var ah = ad.baseHref ? '<base href="' + ad.baseHref + '" data-cke-temp="1" />' : '';
							if (ae)
								ac = ac.replace(/<!DOCTYPE[^>]*>/i, function (ai) {
										J.docType = af = ai;
										return '';
									}).replace(/<\?xml\s[^\?]*\?>/i, function (ai) {
										J.xmlDeclaration = ai;
										return '';
									});
							if (J.dataProcessor)
								ac = J.dataProcessor.toHtml(ac, K);
							if (ae) {
								if (!/<body[\s|>]/.test(ac))
									ac = '<body>' + ac;
								if (!/<html[\s|>]/.test(ac))
									ac = '<html>' + ac + '</html>';
								if (!/<head[\s|>]/.test(ac))
									ac = ac.replace(/<html[^>]*>/, '$&<head><title></title></head>');
								else if (!/<title[\s|>]/.test(ac))
									ac = ac.replace(/<head[^>]*>/, '$&<title></title>');
								ah && (ac = ac.replace(/<head>/, '$&' + ah));
								ac = ac.replace(/<\/head\s*>/, ag + '$&');
								ac = af + ac;
							} else
								ac = ad.docType + '<html dir="' + ad.contentsLangDirection + '"' + ' lang="' + (ad.contentsLanguage || J.langCode) + '">' + '<head>' + '<title>' + L + '</title>' + ah + ag + '</head>' + '<body' + (ad.bodyId ? ' id="' + ad.bodyId + '"' : '') + (ad.bodyClass ? ' class="' + ad.bodyClass + '"' : '') + '>' + ac + '</html>';
							if (g.gecko)
								ac = ac.replace(/<br \/>(?=\s*<\/(:?html|body)>)/, '$&<br type="_moz" />');
							ac += aa;
							this.onDispose();
							Z(ac);
						},
						getData : function () {
							var ac = J.config,
							ad = ac.fullPage,
							ae = ad && J.docType,
							af = ad && J.xmlDeclaration,
							ag = S.getFrameDocument(),
							ah = ad ? ag.getDocumentElement().getOuterHtml() : ag.getBody().getHtml();
							if (g.gecko)
								ah = ah.replace(/<br>(?=\s*(:?$|<\/body>))/, '');
							if (J.dataProcessor)
								ah = J.dataProcessor.toDataFormat(ah, K);
							if (ac.ignoreEmptyParagraph)
								ah = ah.replace(r, function (ai, aj) {
										return aj;
									});
							if (af)
								ah = af + '\n' + ah;
							if (ae)
								ah = ae + '\n' + ah;
							return ah;
						},
						getSnapshotData : function () {
							return S.getFrameDocument().getBody().getHtml();
						},
						loadSnapshotData : function (ac) {
							S.getFrameDocument().getBody().setHtml(ac);
						},
						onDispose : function () {
							if (!J.document)
								return;
							J.document.getDocumentElement().clearCustomData();
							J.document.getBody().clearCustomData();
							J.window.clearCustomData();
							J.document.clearCustomData();
							S.clearCustomData();
							S.remove();
						},
						unload : function (ac) {
							this.onDispose();
							if (X)
								N.removeListener('resize', X);
							J.window = J.document = S = R = U = null;
							J.fire('contentDomUnload');
						},
						focus : function () {
							var ac = J.window;
							if (T)
								U = true;
							else if (ac) {
								var ad = J.getSelection(),
								ae = ad && ad.getNative();
								if (ae && ae.type == 'Control')
									return;
								g.air ? setTimeout(function () {
									ac.focus();
								}, 0) : ac.focus();
								J.selectionChange();
							}
						}
					});
					J.on('insertHtml', w(x), null, null, 20);
					J.on('insertElement', w(z), null, null, 20);
					J.on('insertText', w(y), null, null, 20);
					J.on('selectionChange', function (ac) {
						if (J.readOnly)
							return;
						var ad = J.getSelection();
						if (ad && !ad.isLocked) {
							var ae = J.checkDirty();
							J.fire('saveSnapshot', {
								contentOnly : 1
							});
							I.call(this, ac);
							J.fire('updateSnapshot');
							!ae && J.resetDirty();
						}
					}, null, null, 1);
				});
				J.on('contentDom', function () {
					var R = J.document.getElementsByTag('title').getItem(0);
					R.data('cke-title', J.document.$.title);
					h && (J.document.$.title = L);
				});
				J.on('readOnly', function () {
					if (J.mode == 'wysiwyg') {
						var R = J.getMode();
						R.loadData(R.getData());
					}
				});
				if (f.document.$.documentMode >= 8) {
					J.addCss('html.CSS1Compat [contenteditable=false]{ min-height:0 !important;}');
					var P = [];
					for (var Q in k.$removeEmpty)
						P.push('html.CSS1Compat ' + Q + '[contenteditable=false]');
					J.addCss(P.join(',') + '{ display:inline-block;}');
				} else if (g.gecko) {
					J.addCss('html { height: 100% !important; }');
					J.addCss('img:-moz-broken { -moz-force-broken-image-icon : 1;\tmin-width : 24px; min-height : 24px; }');
				}
				J.addCss('html {\t_overflow-y: scroll; cursor: text;\t*cursor:auto;}');
				J.addCss('img, input, textarea { cursor: default;}');
				J.on('insertElement', function (R) {
					var S = R.data;
					if (S.type == 1 && (S.is('input') || S.is('textarea'))) {
						var T = S.getAttribute('contenteditable') == 'false';
						if (!T) {
							S.data('cke-editable', S.hasAttribute('contenteditable') ? 'true' : '1');
							S.setAttribute('contenteditable', false);
						}
					}
				});
			}
		});
		if (g.gecko)
			(function () {
				var J = document.body;
				if (!J)
					window.addEventListener('load', arguments.callee, false);
				else {
					var K = J.getAttribute('onpageshow');
					J.setAttribute('onpageshow', (K ? K + ';' : '') + 'event.persisted && (function(){' + 'var allInstances = CKEDITOR.instances, editor, doc;' + 'for ( var i in allInstances )' + '{' + '\teditor = allInstances[ i ];' + '\tdoc = editor.document;' + '\tif ( doc )' + '\t{' + '\t\tdoc.$.designMode = "off";' + '\t\tdoc.$.designMode = "on";' + '\t}' + '}' + '})();');
				}
			})();
	})();
	n.disableObjectResizing = false;
	n.disableNativeTableHandles = true;
	n.disableNativeSpellChecker = true;
	n.ignoreEmptyParagraph = true;
	f.DIALOG_RESIZE_NONE = 0;
	f.DIALOG_RESIZE_WIDTH = 1;
	f.DIALOG_RESIZE_HEIGHT = 2;
	f.DIALOG_RESIZE_BOTH = 3;
	(function () {
		var r = j.cssLength;
		function s(W) {
			return !!this._.tabs[W][0].$.offsetHeight;
		};
		function t() {
			var aa = this;
			var W = aa._.currentTabId,
			X = aa._.tabIdList.length,
			Y = j.indexOf(aa._.tabIdList, W) + X;
			for (var Z = Y - 1; Z > Y - X; Z--) {
				if (s.call(aa, aa._.tabIdList[Z % X]))
					return aa._.tabIdList[Z % X];
			}
			return null;
		};
		function u() {
			var aa = this;
			var W = aa._.currentTabId,
			X = aa._.tabIdList.length,
			Y = j.indexOf(aa._.tabIdList, W);
			for (var Z = Y + 1; Z < Y + X; Z++) {
				if (s.call(aa, aa._.tabIdList[Z % X]))
					return aa._.tabIdList[Z % X];
			}
			return null;
		};
		function v(W, X) {
			var Y = W.$.getElementsByTagName('input');
			for (var Z = 0, aa = Y.length; Z < aa; Z++) {
				var ab = new m(Y[Z]);
				if (ab.getAttribute('type').toLowerCase() == 'text')
					if (X) {
						ab.setAttribute('value', ab.getCustomData('fake_value') || '');
						ab.removeCustomData('fake_value');
					} else {
						ab.setCustomData('fake_value', ab.getAttribute('value'));
						ab.setAttribute('value', '');
					}
			}
		};
		function w(W, X) {
			var Z = this;
			var Y = Z.getInputElement();
			if (Y)
				W ? Y.removeAttribute('aria-invalid') : Y.setAttribute('aria-invalid', true);
			if (!W)
				if (Z.select)
					Z.select();
				else
					Z.focus();
			X && alert(X);
			Z.fire('validated', {
				valid : W,
				msg : X
			});
		};
		function x() {
			var W = this.getInputElement();
			W && W.removeAttribute('aria-invalid');
		};
		f.dialog = function (W, X) {
			var Y = f.dialog._.dialogDefinitions[X],
			Z = j.clone(A),
			aa = W.config.dialog_buttonsOrder || 'OS',
			ab = W.lang.dir,
			ac = {},
			ad,
			ae,
			af;
			if (aa == 'OS' && g.mac || aa == 'rtl' && ab == 'ltr' || aa == 'ltr' && ab == 'rtl')
				Z.buttons.reverse();
			Y = j.extend(Y(W), Z);
			Y = j.clone(Y);
			Y = new E(this, Y);
			var ag = f.document,
			ah = W.theme.buildDialog(W);
			this._ = {
				editor : W,
				element : ah.element,
				name : X,
				contentSize : {
					width : 0,
					height : 0
				},
				size : {
					width : 0,
					height : 0
				},
				contents : {},
				buttons : {},
				accessKeyMap : {},
				tabs : {},
				tabIdList : [],
				currentTabId : null,
				currentTabIndex : null,
				pageCount : 0,
				lastTab : null,
				tabBarMode : false,
				focusList : [],
				currentFocusIndex : 0,
				hasFocus : false
			};
			this.parts = ah.parts;
			j.setTimeout(function () {
				W.fire('ariaWidget', this.parts.contents);
			}, 0, this);
			var ai = {
				position : g.ie6Compat ? 'absolute' : 'fixed',
				top : 0,
				visibility : 'hidden'
			};
			ai[ab == 'rtl' ? 'right' : 'left'] = 0;
			this.parts.dialog.setStyles(ai);
			f.event.call(this);
			this.definition = Y = f.fire('dialogDefinition', {
					name : X,
					definition : Y
				}, W).definition;
			if (!('removeDialogTabs' in W._) && W.config.removeDialogTabs) {
				var aj = W.config.removeDialogTabs.split(';');
				for (ad = 0; ad < aj.length; ad++) {
					var ak = aj[ad].split(':');
					if (ak.length == 2) {
						var al = ak[0];
						if (!ac[al])
							ac[al] = [];
						ac[al].push(ak[1]);
					}
				}
				W._.removeDialogTabs = ac;
			}
			if (W._.removeDialogTabs && (ac = W._.removeDialogTabs[X]))
				for (ad = 0; ad < ac.length; ad++)
					Y.removeContents(ac[ad]);
			if (Y.onLoad)
				this.on('load', Y.onLoad);
			if (Y.onShow)
				this.on('show', Y.onShow);
			if (Y.onHide)
				this.on('hide', Y.onHide);
			if (Y.onOk)
				this.on('ok', function (aw) {
					W.fire('saveSnapshot');
					setTimeout(function () {
						W.fire('saveSnapshot');
					}, 0);
					if (Y.onOk.call(this, aw) === false)
						aw.data.hide = false;
				});
			if (Y.onCancel)
				this.on('cancel', function (aw) {
					if (Y.onCancel.call(this, aw) === false)
						aw.data.hide = false;
				});
			var am = this,
			an = function (aw) {
				var ax = am._.contents,
				ay = false;
				for (var az in ax)
					for (var aA in ax[az]) {
						ay = aw.call(this, ax[az][aA]);
						if (ay)
							return;
					}
			};
			this.on('ok', function (aw) {
				an(function (ax) {
					if (ax.validate) {
						var ay = ax.validate(this),
						az = typeof ay == 'string' || ay === false;
						if (az) {
							aw.data.hide = false;
							aw.stop();
						}
						w.call(ax, !az, typeof ay == 'string' ? ay : undefined);
						return az;
					}
				});
			}, this, null, 0);
			this.on('cancel', function (aw) {
				an(function (ax) {
					if (ax.isChanged()) {
						if (!confirm(W.lang.common.confirmCancel))
							aw.data.hide = false;
						return true;
					}
				});
			}, this, null, 0);
			this.parts.close.on('click', function (aw) {
				if (this.fire('cancel', {
						hide : true
					}).hide !== false)
					this.hide();
				aw.data.preventDefault();
			}, this);
			function ao() {
				var aw = am._.focusList;
				aw.sort(function (az, aA) {
					if (az.tabIndex != aA.tabIndex)
						return aA.tabIndex - az.tabIndex;
					else
						return az.focusIndex - aA.focusIndex;
				});
				var ax = aw.length;
				for (var ay = 0; ay < ax; ay++)
					aw[ay].focusIndex = ay;
			};
			function ap(aw) {
				var ax = am._.focusList;
				aw = aw || 0;
				if (ax.length < 1)
					return;
				var ay = am._.currentFocusIndex;
				try {
					ax[ay].getInputElement().$.blur();
				} catch (aB) {}
				
				var az = (ay + aw + ax.length) % ax.length,
				aA = az;
				while (aw && !ax[aA].isFocusable()) {
					aA = (aA + aw + ax.length) % ax.length;
					if (aA == az)
						break;
				}
				ax[aA].focus();
				if (ax[aA].type == 'text')
					ax[aA].select();
			};
			this.changeFocus = ap;
			function aq(aw) {
				var aD = this;
				if (am != f.dialog._.currentTop)
					return;
				var ax = aw.data.getKeystroke(),
				ay = W.lang.dir == 'rtl',
				az;
				ae = af = 0;
				if (ax == 9 || ax == 2000 + 9) {
					var aA = ax == 2000 + 9;
					if (am._.tabBarMode) {
						var aB = aA ? t.call(am) : u.call(am);
						am.selectPage(aB);
						am._.tabs[aB][0].focus();
					} else
						ap(aA ? -1 : 1);
					ae = 1;
				} else if (ax == 4000 + 121 && !am._.tabBarMode && am.getPageCount() > 1) {
					am._.tabBarMode = true;
					am._.tabs[am._.currentTabId][0].focus();
					ae = 1;
				} else if ((ax == 37 || ax == 39) && am._.tabBarMode) {
					aB = ax == (ay ? 39 : 37) ? t.call(am) : u.call(am);
					am.selectPage(aB);
					am._.tabs[aB][0].focus();
					ae = 1;
				} else if ((ax == 13 || ax == 32) && am._.tabBarMode) {
					aD.selectPage(aD._.currentTabId);
					aD._.tabBarMode = false;
					aD._.currentFocusIndex = -1;
					ap(1);
					ae = 1;
				} else if (ax == 13) {
					var aC = aw.data.getTarget();
					if (!aC.is('a', 'button', 'select', 'textarea') && (!aC.is('input') || aC.$.type != 'button')) {
						az = aD.getButton('ok');
						az && j.setTimeout(az.click, 0, az);
						ae = 1;
					}
					af = 1;
				} else if (ax == 27) {
					az = aD.getButton('cancel');
					if (az)
						j.setTimeout(az.click, 0, az);
					else if (aD.fire('cancel', {
							hide : true
						}).hide !== false)
						aD.hide();
					af = 1;
				} else
					return;
				ar(aw);
			};
			function ar(aw) {
				if (ae)
					aw.data.preventDefault(1);
				else if (af)
					aw.data.stopPropagation();
			};
			var as = this._.element;
			this.on('show', function () {
				as.on('keydown', aq, this);
				if (g.opera || g.gecko)
					as.on('keypress', ar, this);
			});
			this.on('hide', function () {
				as.removeListener('keydown', aq);
				if (g.opera || g.gecko)
					as.removeListener('keypress', ar);
				an(function (aw) {
					x.apply(aw);
				});
			});
			this.on('iframeAdded', function (aw) {
				var ax = new l(aw.data.iframe.$.contentWindow.document);
				ax.on('keydown', aq, this, null, 0);
			});
			this.on('show', function () {
				var aA = this;
				ao();
				if (W.config.dialog_startupFocusTab && am._.pageCount > 1) {
					am._.tabBarMode = true;
					am._.tabs[am._.currentTabId][0].focus();
				} else if (!aA._.hasFocus) {
					aA._.currentFocusIndex = -1;
					if (Y.onFocus) {
						var aw = Y.onFocus.call(aA);
						aw && aw.focus();
					} else
						ap(1);
					if (aA._.editor.mode == 'wysiwyg' && h) {
						var ax = W.document.$.selection,
						ay = ax.createRange();
						if (ay)
							if (ay.parentElement && ay.parentElement().ownerDocument == W.document.$ || ay.item && ay.item(0).ownerDocument == W.document.$) {
								var az = document.body.createTextRange();
								az.moveToElementText(aA.getElement().getFirst().$);
								az.collapse(true);
								az.select();
							}
					}
				}
			}, this, null, 4294967295);
			if (g.ie6Compat)
				this.on('load', function (aw) {
					var ax = this.getElement(),
					ay = ax.getFirst();
					ay.remove();
					ay.appendTo(ax);
				}, this);
			G(this);
			H(this);
			new i.text(Y.title, f.document).appendTo(this.parts.title);
			for (ad = 0; ad < Y.contents.length; ad++) {
				var at = Y.contents[ad];
				at && this.addPage(at);
			}
			this.parts.tabs.on('click', function (aw) {
				var az = this;
				var ax = aw.data.getTarget();
				if (ax.hasClass('cke_dialog_tab')) {
					var ay = ax.$.id;
					az.selectPage(ay.substring(4, ay.lastIndexOf('_')));
					if (az._.tabBarMode) {
						az._.tabBarMode = false;
						az._.currentFocusIndex = -1;
						ap(1);
					}
					aw.data.preventDefault();
				}
			}, this);
			var au = [],
			av = f.dialog._.uiElementBuilders.hbox.build(this, {
					type : 'hbox',
					className : 'cke_dialog_footer_buttons',
					widths : [],
					children : Y.buttons
				}, au).getChild();
			this.parts.footer.setHtml(au.join(''));
			for (ad = 0; ad < av.length; ad++)
				this._.buttons[av[ad].id] = av[ad];
		};
		function y(W, X, Y) {
			this.element = X;
			this.focusIndex = Y;
			this.tabIndex = 0;
			this.isFocusable = function () {
				return !X.getAttribute('disabled') && X.isVisible();
			};
			this.focus = function () {
				W._.currentFocusIndex = this.focusIndex;
				this.element.focus();
			};
			X.on('keydown', function (Z) {
				if (Z.data.getKeystroke()in {
					32 : 1,
					13 : 1
				})
					this.fire('click');
			});
			X.on('focus', function () {
				this.fire('mouseover');
			});
			X.on('blur', function () {
				this.fire('mouseout');
			});
		};
		function z(W) {
			var X = f.document.getWindow();
			function Y() {
				W.layout();
			};
			X.on('resize', Y);
			W.on('hide', function () {
				X.removeListener('resize', Y);
			});
		};
		f.dialog.prototype = {
			destroy : function () {
				this.hide();
				this._.element.remove();
			},
			resize : (function () {
				return function (W, X) {
					var Y = this;
					if (Y._.contentSize && Y._.contentSize.width == W && Y._.contentSize.height == X)
						return;
					f.dialog.fire('resize', {
						dialog : Y,
						skin : Y._.editor.skinName,
						width : W,
						height : X
					}, Y._.editor);
					Y.fire('resize', {
						skin : Y._.editor.skinName,
						width : W,
						height : X
					}, Y._.editor);
					if (Y._.editor.lang.dir == 'rtl' && Y._.position)
						Y._.position.x = f.document.getWindow().getViewPaneSize().width - Y._.contentSize.width - parseInt(Y._.element.getFirst().getStyle('right'), 10);
					Y._.contentSize = {
						width : W,
						height : X
					};
				};
			})(),
			getSize : function () {
				var W = this._.element.getFirst();
				return {
					width : W.$.offsetWidth || 0,
					height : W.$.offsetHeight || 0
				};
			},
			move : function (W, X, Y) {
				var ag = this;
				var Z = ag._.element.getFirst(),
				aa = ag._.editor.lang.dir == 'rtl',
				ab = Z.getComputedStyle('position') == 'fixed';
				Z.setStyle('zoom', '100%');
				if (ab && ag._.position && ag._.position.x == W && ag._.position.y == X)
					return;
				ag._.position = {
					x : W,
					y : X
				};
				if (!ab) {
					var ac = f.document.getWindow().getScrollPosition();
					W += ac.x;
					X += ac.y;
				}
				if (aa) {
					var ad = ag.getSize(),
					ae = f.document.getWindow().getViewPaneSize();
					W = ae.width - ad.width - W;
				}
				var af = {
					top : (X > 0 ? X : 0) + 'px'
				};
				af[aa ? 'right' : 'left'] = (W > 0 ? W : 0) + 'px';
				Z.setStyles(af);
				Y && (ag._.moved = 1);
			},
			getPosition : function () {
				return j.extend({}, this._.position);
			},
			show : function () {
				var W = this._.element,
				X = this.definition;
				if (!(W.getParent() && W.getParent().equals(f.document.getBody())))
					W.appendTo(f.document.getBody());
				else
					W.setStyle('display', 'block');
				if (g.gecko && g.version < 10900) {
					var Y = this.parts.dialog;
					Y.setStyle('position', 'absolute');
					setTimeout(function () {
						Y.setStyle('position', 'fixed');
					}, 0);
				}
				this.resize(this._.contentSize && this._.contentSize.width || X.width || X.minWidth, this._.contentSize && this._.contentSize.height || X.height || X.minHeight);
				this.reset();
				this.selectPage(this.definition.contents[0].id);
				if (f.dialog._.currentZIndex === null)
					f.dialog._.currentZIndex = this._.editor.config.baseFloatZIndex;
				this._.element.getFirst().setStyle('z-index', f.dialog._.currentZIndex += 10);
				if (f.dialog._.currentTop === null) {
					f.dialog._.currentTop = this;
					this._.parentDialog = null;
					M(this._.editor);
				} else {
					this._.parentDialog = f.dialog._.currentTop;
					var Z = this._.parentDialog.getElement().getFirst();
					Z.$.style.zIndex -= Math.floor(this._.editor.config.baseFloatZIndex / 2);
					f.dialog._.currentTop = this;
				}
				W.on('keydown', Q);
				W.on(g.opera ? 'keypress' : 'keyup', R);
				this._.hasFocus = false;
				j.setTimeout(function () {
					this.layout();
					z(this);
					this.parts.dialog.setStyle('visibility', '');
					this.fireOnce('load', {});
					p.fire('ready', this);
					this.fire('show', {});
					this._.editor.fire('dialogShow', this);
					this.foreach(function (aa) {
						aa.setInitValue && aa.setInitValue();
					});
				}, 100, this);
			},
			layout : function () {
				var ac = this;
				var W = ac.parts.dialog,
				X = ac.getSize(),
				Y = f.document.getWindow(),
				Z = Y.getViewPaneSize(),
				aa = (Z.width - X.width) / 2,
				ab = (Z.height - X.height) / 2;
				if (!g.ie6Compat)
					if (X.height + (ab > 0 ? ab : 0) > Z.height || X.width + (aa > 0 ? aa : 0) > Z.width)
						W.setStyle('position', 'absolute');
					else
						W.setStyle('position', 'fixed');
				ac.move(ac._.moved ? ac._.position.x : aa, ac._.moved ? ac._.position.y : ab);
			},
			foreach : function (W) {
				var Z = this;
				for (var X in Z._.contents)
					for (var Y in Z._.contents[X])
						W.call(Z, Z._.contents[X][Y]);
				return Z;
			},
			reset : (function () {
				var W = function (X) {
					if (X.reset)
						X.reset(1);
				};
				return function () {
					this.foreach(W);
					return this;
				};
			})(),
			setupContent : function () {
				var W = arguments;
				this.foreach(function (X) {
					if (X.setup)
						X.setup.apply(X, W);
				});
			},
			commitContent : function () {
				var W = arguments;
				this.foreach(function (X) {
					if (h && this._.currentFocusIndex == X.focusIndex)
						X.getInputElement().$.blur();
					if (X.commit)
						X.commit.apply(X, W);
				});
			},
			hide : function () {
				if (!this.parts.dialog.isVisible())
					return;
				this.fire('hide', {});
				this._.editor.fire('dialogHide', this);
				this.selectPage(this._.tabIdList[0]);
				var W = this._.element;
				W.setStyle('display', 'none');
				this.parts.dialog.setStyle('visibility', 'hidden');
				T(this);
				while (f.dialog._.currentTop != this)
					f.dialog._.currentTop.hide();
				if (!this._.parentDialog)
					N();
				else {
					var X = this._.parentDialog.getElement().getFirst();
					X.setStyle('z-index', parseInt(X.$.style.zIndex, 10) + Math.floor(this._.editor.config.baseFloatZIndex / 2));
				}
				f.dialog._.currentTop = this._.parentDialog;
				if (!this._.parentDialog) {
					f.dialog._.currentZIndex = null;
					W.removeListener('keydown', Q);
					W.removeListener(g.opera ? 'keypress' : 'keyup', R);
					var Y = this._.editor;
					Y.focus();
					if (Y.mode == 'wysiwyg' && h) {
						var Z = Y.getSelection();
						Z && Z.unlock(true);
					}
				} else
					f.dialog._.currentZIndex -= 10;
				delete this._.parentDialog;
				this.foreach(function (aa) {
					aa.resetInitValue && aa.resetInitValue();
				});
			},
			addPage : function (W) {
				var ai = this;
				var X = [],
				Y = W.label ? ' title="' + j.htmlEncode(W.label) + '"' : '',
				Z = W.elements,
				aa = f.dialog._.uiElementBuilders.vbox.build(ai, {
						type : 'vbox',
						className : 'cke_dialog_page_contents',
						children : W.elements,
						expand : !!W.expand,
						padding : W.padding,
						style : W.style || 'width: 100%;height:100%'
					}, X),
				ab = m.createFromHtml(X.join(''));
				ab.setAttribute('role', 'tabpanel');
				var ac = g,
				ad = 'cke_' + W.id + '_' + j.getNextNumber(),
				ae = m.createFromHtml(['<a class="cke_dialog_tab"', ai._.pageCount > 0 ? ' cke_last' : 'cke_first', Y, !!W.hidden ? ' style="display:none"' : '', ' id="', ad, '"', ac.gecko && ac.version >= 10900 && !ac.hc ? '' : ' href="javascript:void(0)"', ' tabIndex="-1"', ' hidefocus="true"', ' role="tab">', W.label, '</a>'].join(''));
				ab.setAttribute('aria-labelledby', ad);
				ai._.tabs[W.id] = [ae, ab];
				ai._.tabIdList.push(W.id);
				!W.hidden && ai._.pageCount++;
				ai._.lastTab = ae;
				ai.updateStyle();
				var af = ai._.contents[W.id] = {},
				ag,
				ah = aa.getChild();
				while (ag = ah.shift()) {
					af[ag.id] = ag;
					if (typeof ag.getChild == 'function')
						ah.push.apply(ah, ag.getChild());
				}
				ab.setAttribute('name', W.id);
				ab.appendTo(ai.parts.contents);
				ae.unselectable();
				ai.parts.tabs.append(ae);
				if (W.accessKey) {
					S(ai, ai, 'CTRL+' + W.accessKey, V, U);
					ai._.accessKeyMap['CTRL+' + W.accessKey] = W.id;
				}
			},
			selectPage : function (W) {
				if (this._.currentTabId == W)
					return;
				if (this.fire('selectPage', {
						page : W,
						currentPage : this._.currentTabId
					}) === true)
					return;
				for (var X in this._.tabs) {
					var Y = this._.tabs[X][0],
					Z = this._.tabs[X][1];
					if (X != W) {
						Y.removeClass('cke_dialog_tab_selected');
						Z.hide();
					}
					Z.setAttribute('aria-hidden', X != W);
				}
				var aa = this._.tabs[W];
				aa[0].addClass('cke_dialog_tab_selected');
				if (g.ie6Compat || g.ie7Compat) {
					v(aa[1]);
					aa[1].show();
					setTimeout(function () {
						v(aa[1], 1);
					}, 0);
				} else
					aa[1].show();
				this._.currentTabId = W;
				this._.currentTabIndex = j.indexOf(this._.tabIdList, W);
			},
			updateStyle : function () {
				this.parts.dialog[(this._.pageCount === 1 ? 'add' : 'remove') + 'Class']('cke_single_page');
			},
			hidePage : function (W) {
				var Y = this;
				var X = Y._.tabs[W] && Y._.tabs[W][0];
				if (!X || Y._.pageCount == 1 || !X.isVisible())
					return;
				else if (W == Y._.currentTabId)
					Y.selectPage(t.call(Y));
				X.hide();
				Y._.pageCount--;
				Y.updateStyle();
			},
			showPage : function (W) {
				var Y = this;
				var X = Y._.tabs[W] && Y._.tabs[W][0];
				if (!X)
					return;
				X.show();
				Y._.pageCount++;
				Y.updateStyle();
			},
			getElement : function () {
				return this._.element;
			},
			getName : function () {
				return this._.name;
			},
			getContentElement : function (W, X) {
				var Y = this._.contents[W];
				return Y && Y[X];
			},
			getValueOf : function (W, X) {
				return this.getContentElement(W, X).getValue();
			},
			setValueOf : function (W, X, Y) {
				return this.getContentElement(W, X).setValue(Y);
			},
			getButton : function (W) {
				return this._.buttons[W];
			},
			click : function (W) {
				return this._.buttons[W].click();
			},
			disableButton : function (W) {
				return this._.buttons[W].disable();
			},
			enableButton : function (W) {
				return this._.buttons[W].enable();
			},
			getPageCount : function () {
				return this._.pageCount;
			},
			getParentEditor : function () {
				return this._.editor;
			},
			getSelectedElement : function () {
				return this.getParentEditor().getSelection().getSelectedElement();
			},
			addFocusable : function (W, X) {
				var Z = this;
				if (typeof X == 'undefined') {
					X = Z._.focusList.length;
					Z._.focusList.push(new y(Z, W, X));
				} else {
					Z._.focusList.splice(X, 0, new y(Z, W, X));
					for (var Y = X + 1; Y < Z._.focusList.length; Y++)
						Z._.focusList[Y].focusIndex++;
				}
			}
		};
		j.extend(f.dialog, {
			add : function (W, X) {
				if (!this._.dialogDefinitions[W] || typeof X == 'function')
					this._.dialogDefinitions[W] = X;
			},
			exists : function (W) {
				return !!this._.dialogDefinitions[W];
			},
			getCurrent : function () {
				return f.dialog._.currentTop;
			},
			okButton : (function () {
				var W = function (X, Y) {
					Y = Y || {};
					return j.extend({
						id : 'ok',
						type : 'button',
						label : X.lang.common.ok,
						'class' : 'cke_dialog_ui_button_ok',
						onClick : function (Z) {
							var aa = Z.data.dialog;
							if (aa.fire('ok', {
									hide : true
								}).hide !== false)
								aa.hide();
						}
					}, Y, true);
				};
				W.type = 'button';
				W.override = function (X) {
					return j.extend(function (Y) {
						return W(Y, X);
					}, {
						type : 'button'
					}, true);
				};
				return W;
			})(),
			cancelButton : (function () {
				var W = function (X, Y) {
					Y = Y || {};
					return j.extend({
						id : 'cancel',
						type : 'button',
						label : X.lang.common.cancel,
						'class' : 'cke_dialog_ui_button_cancel',
						onClick : function (Z) {
							var aa = Z.data.dialog;
							if (aa.fire('cancel', {
									hide : true
								}).hide !== false)
								aa.hide();
						}
					}, Y, true);
				};
				W.type = 'button';
				W.override = function (X) {
					return j.extend(function (Y) {
						return W(Y, X);
					}, {
						type : 'button'
					}, true);
				};
				return W;
			})(),
			addUIElement : function (W, X) {
				this._.uiElementBuilders[W] = X;
			}
		});
		f.dialog._ = {
			uiElementBuilders : {},
			dialogDefinitions : {},
			currentTop : null,
			currentZIndex : null
		};
		f.event.implementOn(f.dialog);
		f.event.implementOn(f.dialog.prototype, true);
		var A = {
			resizable : 3,
			minWidth : 600,
			minHeight : 400,
			buttons : [f.dialog.okButton, f.dialog.cancelButton]
		},
		B = function (W, X, Y) {
			for (var Z = 0, aa; aa = W[Z]; Z++) {
				if (aa.id == X)
					return aa;
				if (Y && aa[Y]) {
					var ab = B(aa[Y], X, Y);
					if (ab)
						return ab;
				}
			}
			return null;
		},
		C = function (W, X, Y, Z, aa) {
			if (Y) {
				for (var ab = 0, ac; ac = W[ab]; ab++) {
					if (ac.id == Y) {
						W.splice(ab, 0, X);
						return X;
					}
					if (Z && ac[Z]) {
						var ad = C(ac[Z], X, Y, Z, true);
						if (ad)
							return ad;
					}
				}
				if (aa)
					return null;
			}
			W.push(X);
			return X;
		},
		D = function (W, X, Y) {
			for (var Z = 0, aa; aa = W[Z]; Z++) {
				if (aa.id == X)
					return W.splice(Z, 1);
				if (Y && aa[Y]) {
					var ab = D(aa[Y], X, Y);
					if (ab)
						return ab;
				}
			}
			return null;
		},
		E = function (W, X) {
			this.dialog = W;
			var Y = X.contents;
			for (var Z = 0, aa; aa = Y[Z]; Z++)
				Y[Z] = aa && new F(W, aa);
			j.extend(this, X);
		};
		E.prototype = {
			getContents : function (W) {
				return B(this.contents, W);
			},
			getButton : function (W) {
				return B(this.buttons, W);
			},
			addContents : function (W, X) {
				return C(this.contents, W, X);
			},
			addButton : function (W, X) {
				return C(this.buttons, W, X);
			},
			removeContents : function (W) {
				D(this.contents, W);
			},
			removeButton : function (W) {
				D(this.buttons, W);
			}
		};
		function F(W, X) {
			this._ = {
				dialog : W
			};
			j.extend(this, X);
		};
		F.prototype = {
			get : function (W) {
				return B(this.elements, W, 'children');
			},
			add : function (W, X) {
				return C(this.elements, W, X, 'children');
			},
			remove : function (W) {
				D(this.elements, W, 'children');
			}
		};
		function G(W) {
			var X = null,
			Y = null,
			Z = W.getElement().getFirst(),
			aa = W.getParentEditor(),
			ab = aa.config.dialog_magnetDistance,
			ac = aa.skin.margins || [0, 0, 0, 0];
			if (typeof ab == 'undefined')
				ab = 20;
			function ad(af) {
				var ag = W.getSize(),
				ah = f.document.getWindow().getViewPaneSize(),
				ai = af.data.$.screenX,
				aj = af.data.$.screenY,
				ak = ai - X.x,
				al = aj - X.y,
				am,
				an;
				X = {
					x : ai,
					y : aj
				};
				Y.x += ak;
				Y.y += al;
				if (Y.x + ac[3] < ab)
					am = -ac[3];
				else if (Y.x - ac[1] > ah.width - ag.width - ab)
					am = ah.width - ag.width + (aa.lang.dir == 'rtl' ? 0 : ac[1]);
				else
					am = Y.x;
				if (Y.y + ac[0] < ab)
					an = -ac[0];
				else if (Y.y - ac[2] > ah.height - ag.height - ab)
					an = ah.height - ag.height + ac[2];
				else
					an = Y.y;
				W.move(am, an, 1);
				af.data.preventDefault();
			};
			function ae(af) {
				f.document.removeListener('mousemove', ad);
				f.document.removeListener('mouseup', ae);
				if (g.ie6Compat) {
					var ag = K.getChild(0).getFrameDocument();
					ag.removeListener('mousemove', ad);
					ag.removeListener('mouseup', ae);
				}
			};
			W.parts.title.on('mousedown', function (af) {
				X = {
					x : af.data.$.screenX,
					y : af.data.$.screenY
				};
				f.document.on('mousemove', ad);
				f.document.on('mouseup', ae);
				Y = W.getPosition();
				if (g.ie6Compat) {
					var ag = K.getChild(0).getFrameDocument();
					ag.on('mousemove', ad);
					ag.on('mouseup', ae);
				}
				af.data.preventDefault();
			}, W);
		};
		function H(W) {
			var X = W.definition,
			Y = X.resizable;
			if (Y == 0)
				return;
			var Z = W.getParentEditor(),
			aa,
			ab,
			ac,
			ad,
			ae,
			af,
			ag = j.addFunction(function (aj) {
					ae = W.getSize();
					var ak = W.parts.contents,
					al = ak.$.getElementsByTagName('iframe').length;
					if (al) {
						af = m.createFromHtml('<div class="cke_dialog_resize_cover" style="height: 100%; position: absolute; width: 100%;"></div>');
						ak.append(af);
					}
					ab = ae.height - W.parts.contents.getSize('height', !(g.gecko || g.opera || h && g.quirks));
					aa = ae.width - W.parts.contents.getSize('width', 1);
					ad = {
						x : aj.screenX,
						y : aj.screenY
					};
					ac = f.document.getWindow().getViewPaneSize();
					f.document.on('mousemove', ah);
					f.document.on('mouseup', ai);
					if (g.ie6Compat) {
						var am = K.getChild(0).getFrameDocument();
						am.on('mousemove', ah);
						am.on('mouseup', ai);
					}
					aj.preventDefault && aj.preventDefault();
				});
			W.on('load', function () {
				var aj = '';
				if (Y == 1)
					aj = ' cke_resizer_horizontal';
				else if (Y == 2)
					aj = ' cke_resizer_vertical';
				var ak = m.createFromHtml('<div class="cke_resizer' + aj + ' cke_resizer_' + Z.lang.dir + '"' + ' title="' + j.htmlEncode(Z.lang.resize) + '"' + ' onmousedown="CKEDITOR.tools.callFunction(' + ag + ', event )"></div>');
				W.parts.footer.append(ak, 1);
			});
			Z.on('destroy', function () {
				j.removeFunction(ag);
			});
			function ah(aj) {
				var ak = Z.lang.dir == 'rtl',
				al = (aj.data.$.screenX - ad.x) * (ak ? -1 : 1),
				am = aj.data.$.screenY - ad.y,
				an = ae.width,
				ao = ae.height,
				ap = an + al * (W._.moved ? 1 : 2),
				aq = ao + am * (W._.moved ? 1 : 2),
				ar = W._.element.getFirst(),
				as = ak && ar.getComputedStyle('right'),
				at = W.getPosition();
				if (at.y + aq > ac.height)
					aq = ac.height - at.y;
				if ((ak ? as : at.x) + ap > ac.width)
					ap = ac.width - (ak ? as : at.x);
				if (Y == 1 || Y == 3)
					an = Math.max(X.minWidth || 0, ap - aa);
				if (Y == 2 || Y == 3)
					ao = Math.max(X.minHeight || 0, aq - ab);
				W.resize(an, ao);
				if (!W._.moved)
					W.layout();
				aj.data.preventDefault();
			};
			function ai() {
				f.document.removeListener('mouseup', ai);
				f.document.removeListener('mousemove', ah);
				if (af) {
					af.remove();
					af = null;
				}
				if (g.ie6Compat) {
					var aj = K.getChild(0).getFrameDocument();
					aj.removeListener('mouseup', ai);
					aj.removeListener('mousemove', ah);
				}
			};
		};
		var I,
		J = {},
		K;
		function L(W) {
			W.data.preventDefault(1);
		};
		function M(W) {
			var X = f.document.getWindow(),
			Y = W.config,
			Z = Y.dialog_backgroundCoverColor || 'white',
			aa = Y.dialog_backgroundCoverOpacity,
			ab = Y.baseFloatZIndex,
			ac = j.genKey(Z, aa, ab),
			ad = J[ac];
			if (!ad) {
				var ae = ['<div tabIndex="-1" style="position: ', g.ie6Compat ? 'absolute' : 'fixed', '; z-index: ', ab, '; top: 0px; left: 0px; ', !g.ie6Compat ? 'background-color: ' + Z : '', '" class="cke_dialog_background_cover">'];
				if (g.ie6Compat) {
					var af = g.isCustomDomain(),
					ag = "<html><body style=\\'background-color:" + Z + ";\\'></body></html>";
					ae.push('<iframe hidefocus="true" frameborder="0" id="cke_dialog_background_iframe" src="javascript:');
					ae.push('void((function(){document.open();' + (af ? "document.domain='" + document.domain + "';" : '') + "document.write( '" + ag + "' );" + 'document.close();' + '})())');
					ae.push('" style="position:absolute;left:0;top:0;width:100%;height: 100%;progid:DXImageTransform.Microsoft.Alpha(opacity=0)"></iframe>');
				}
				ae.push('</div>');
				ad = m.createFromHtml(ae.join(''));
				ad.setOpacity(aa != undefined ? aa : 0.5);
				ad.on('keydown', L);
				ad.on('keypress', L);
				ad.on('keyup', L);
				ad.appendTo(f.document.getBody());
				J[ac] = ad;
			} else
				ad.show();
			K = ad;
			var ah = function () {
				var ak = X.getViewPaneSize();
				ad.setStyles({
					width : ak.width + 'px',
					height : ak.height + 'px'
				});
			},
			ai = function () {
				var ak = X.getScrollPosition(),
				al = f.dialog._.currentTop;
				ad.setStyles({
					left : ak.x + 'px',
					top : ak.y + 'px'
				});
				if (al)
					do {
						var am = al.getPosition();
						al.move(am.x, am.y);
					} while (al = al._.parentDialog)
			};
			I = ah;
			X.on('resize', ah);
			ah();
			if (!(g.mac && g.webkit))
				ad.focus();
			if (g.ie6Compat) {
				var aj = function () {
					ai();
					arguments.callee.prevScrollHandler.apply(this, arguments);
				};
				X.$.setTimeout(function () {
					aj.prevScrollHandler = window.onscroll || (function () {});
					window.onscroll = aj;
				}, 0);
				ai();
			}
		};
		function N() {
			if (!K)
				return;
			var W = f.document.getWindow();
			K.hide();
			W.removeListener('resize', I);
			if (g.ie6Compat)
				W.$.setTimeout(function () {
					var X = window.onscroll && window.onscroll.prevScrollHandler;
					window.onscroll = X || null;
				}, 0);
			I = null;
		};
		function O() {
			for (var W in J)
				J[W].remove();
			J = {};
		};
		var P = {},
		Q = function (W) {
			var X = W.data.$.ctrlKey || W.data.$.metaKey,
			Y = W.data.$.altKey,
			Z = W.data.$.shiftKey,
			aa = String.fromCharCode(W.data.$.keyCode),
			ab = P[(X ? 'CTRL+' : '') + (Y ? 'ALT+' : '') + (Z ? 'SHIFT+' : '') + aa];
			if (!ab || !ab.length)
				return;
			ab = ab[ab.length - 1];
			ab.keydown && ab.keydown.call(ab.uiElement, ab.dialog, ab.key);
			W.data.preventDefault();
		},
		R = function (W) {
			var X = W.data.$.ctrlKey || W.data.$.metaKey,
			Y = W.data.$.altKey,
			Z = W.data.$.shiftKey,
			aa = String.fromCharCode(W.data.$.keyCode),
			ab = P[(X ? 'CTRL+' : '') + (Y ? 'ALT+' : '') + (Z ? 'SHIFT+' : '') + aa];
			if (!ab || !ab.length)
				return;
			ab = ab[ab.length - 1];
			if (ab.keyup) {
				ab.keyup.call(ab.uiElement, ab.dialog, ab.key);
				W.data.preventDefault();
			}
		},
		S = function (W, X, Y, Z, aa) {
			var ab = P[Y] || (P[Y] = []);
			ab.push({
				uiElement : W,
				dialog : X,
				key : Y,
				keyup : aa || W.accessKeyUp,
				keydown : Z || W.accessKeyDown
			});
		},
		T = function (W) {
			for (var X in P) {
				var Y = P[X];
				for (var Z = Y.length - 1; Z >= 0; Z--) {
					if (Y[Z].dialog == W || Y[Z].uiElement == W)
						Y.splice(Z, 1);
				}
				if (Y.length === 0)
					delete P[X];
			}
		},
		U = function (W, X) {
			if (W._.accessKeyMap[X])
				W.selectPage(W._.accessKeyMap[X]);
		},
		V = function (W, X) {};
		(function () {
			p.dialog = {
				uiElement : function (W, X, Y, Z, aa, ab, ac) {
					if (arguments.length < 4)
						return;
					var ad = (Z.call ? Z(X) : Z) || 'div',
					ae = ['<', ad, ' '],
					af = (aa && aa.call ? aa(X) : aa) || {},
					ag = (ab && ab.call ? ab(X) : ab) || {},
					ah = (ac && ac.call ? ac.call(this, W, X) : ac) || '',
					ai = this.domId = ag.id || j.getNextId() + '_uiElement',
					aj = this.id = X.id,
					ak;
					ag.id = ai;
					var al = {};
					if (X.type)
						al['cke_dialog_ui_' + X.type] = 1;
					if (X.className)
						al[X.className] = 1;
					if (X.disabled)
						al.cke_disabled = 1;
					var am = ag['class'] && ag['class'].split ? ag['class'].split(' ') : [];
					for (ak = 0; ak < am.length; ak++) {
						if (am[ak])
							al[am[ak]] = 1;
					}
					var an = [];
					for (ak in al)
						an.push(ak);
					ag['class'] = an.join(' ');
					if (X.title)
						ag.title = X.title;
					var ao = (X.style || '').split(';');
					if (X.align) {
						var ap = X.align;
						af['margin-left'] = ap == 'left' ? 0 : 'auto';
						af['margin-right'] = ap == 'right' ? 0 : 'auto';
					}
					for (ak in af)
						ao.push(ak + ':' + af[ak]);
					if (X.hidden)
						ao.push('display:none');
					for (ak = ao.length - 1; ak >= 0; ak--) {
						if (ao[ak] === '')
							ao.splice(ak, 1);
					}
					if (ao.length > 0)
						ag.style = (ag.style ? ag.style + '; ' : '') + ao.join('; ');
					for (ak in ag)
						ae.push(ak + '="' + j.htmlEncode(ag[ak]) + '" ');
					ae.push('>', ah, '</', ad, '>');
					Y.push(ae.join(''));
					(this._ || (this._ = {})).dialog = W;
					if (typeof X.isChanged == 'boolean')
						this.isChanged = function () {
							return X.isChanged;
						};
					if (typeof X.isChanged == 'function')
						this.isChanged = X.isChanged;
					if (typeof X.setValue == 'function')
						this.setValue = j.override(this.setValue, function (ar) {
								return function (as) {
									ar.call(this, X.setValue.call(this, as));
								};
							});
					if (typeof X.getValue == 'function')
						this.getValue = j.override(this.getValue, function (ar) {
								return function () {
									return X.getValue.call(this, ar.call(this));
								};
							});
					f.event.implementOn(this);
					this.registerEvents(X);
					if (this.accessKeyUp && this.accessKeyDown && X.accessKey)
						S(this, W, 'CTRL+' + X.accessKey);
					var aq = this;
					W.on('load', function () {
						var ar = aq.getInputElement();
						if (ar) {
							var as = aq.type in {
								checkbox : 1,
								ratio : 1
							}
							 && h && g.version < 8 ? 'cke_dialog_ui_focused' : '';
							ar.on('focus', function () {
								W._.tabBarMode = false;
								W._.hasFocus = true;
								aq.fire('focus');
								as && this.addClass(as);
							});
							ar.on('blur', function () {
								aq.fire('blur');
								as && this.removeClass(as);
							});
						}
					});
					if (this.keyboardFocusable) {
						this.tabIndex = X.tabIndex || 0;
						this.focusIndex = W._.focusList.push(this) - 1;
						this.on('focus', function () {
							W._.currentFocusIndex = aq.focusIndex;
						});
					}
					j.extend(this, X);
				},
				hbox : function (W, X, Y, Z, aa) {
					if (arguments.length < 4)
						return;
					this._ || (this._ = {});
					var ab = this._.children = X,
					ac = aa && aa.widths || null,
					ad = aa && aa.height || null,
					ae = {},
					af,
					ag = function () {
						var ai = ['<tbody><tr class="cke_dialog_ui_hbox">'];
						for (af = 0; af < Y.length; af++) {
							var aj = 'cke_dialog_ui_hbox_child',
							ak = [];
							if (af === 0)
								aj = 'cke_dialog_ui_hbox_first';
							if (af == Y.length - 1)
								aj = 'cke_dialog_ui_hbox_last';
							ai.push('<td class="', aj, '" role="presentation" ');
							if (ac) {
								if (ac[af])
									ak.push('width:' + r(ac[af]));
							} else
								ak.push('width:' + Math.floor(100 / Y.length) + '%');
							if (ad)
								ak.push('height:' + r(ad));
							if (aa && aa.padding != undefined)
								ak.push('padding:' + r(aa.padding));
							if (h && g.quirks && ab[af].align)
								ak.push('text-align:' + ab[af].align);
							if (ak.length > 0)
								ai.push('style="' + ak.join('; ') + '" ');
							ai.push('>', Y[af], '</td>');
						}
						ai.push('</tr></tbody>');
						return ai.join('');
					},
					ah = {
						role : 'presentation'
					};
					aa && aa.align && (ah.align = aa.align);
					p.dialog.uiElement.call(this, W, aa || {
						type : 'hbox'
					}, Z, 'table', ae, ah, ag);
				},
				vbox : function (W, X, Y, Z, aa) {
					if (arguments.length < 3)
						return;
					this._ || (this._ = {});
					var ab = this._.children = X,
					ac = aa && aa.width || null,
					ad = aa && aa.heights || null,
					ae = function () {
						var af = ['<table role="presentation" cellspacing="0" border="0" '];
						af.push('style="');
						if (aa && aa.expand)
							af.push('height:100%;');
						af.push('width:' + r(ac || '100%'), ';');
						af.push('"');
						af.push('align="', j.htmlEncode(aa && aa.align || (W.getParentEditor().lang.dir == 'ltr' ? 'left' : 'right')), '" ');
						af.push('><tbody>');
						for (var ag = 0; ag < Y.length; ag++) {
							var ah = [];
							af.push('<tr><td role="presentation" ');
							if (ac)
								ah.push('width:' + r(ac || '100%'));
							if (ad)
								ah.push('height:' + r(ad[ag]));
							else if (aa && aa.expand)
								ah.push('height:' + Math.floor(100 / Y.length) + '%');
							if (aa && aa.padding != undefined)
								ah.push('padding:' + r(aa.padding));
							if (h && g.quirks && ab[ag].align)
								ah.push('text-align:' + ab[ag].align);
							if (ah.length > 0)
								af.push('style="', ah.join('; '), '" ');
							af.push(' class="cke_dialog_ui_vbox_child">', Y[ag], '</td></tr>');
						}
						af.push('</tbody></table>');
						return af.join('');
					};
					p.dialog.uiElement.call(this, W, aa || {
						type : 'vbox'
					}, Z, 'div', null, {
						role : 'presentation'
					}, ae);
				}
			};
		})();
		p.dialog.uiElement.prototype = {
			getElement : function () {
				return f.document.getById(this.domId);
			},
			getInputElement : function () {
				return this.getElement();
			},
			getDialog : function () {
				return this._.dialog;
			},
			setValue : function (W, X) {
				this.getInputElement().setValue(W);
				!X && this.fire('change', {
					value : W
				});
				return this;
			},
			getValue : function () {
				return this.getInputElement().getValue();
			},
			isChanged : function () {
				return false;
			},
			selectParentTab : function () {
				var Z = this;
				var W = Z.getInputElement(),
				X = W,
				Y;
				while ((X = X.getParent()) && X.$.className.search('cke_dialog_page_contents') == -1) {}
				
				if (!X)
					return Z;
				Y = X.getAttribute('name');
				if (Z._.dialog._.currentTabId != Y)
					Z._.dialog.selectPage(Y);
				return Z;
			},
			focus : function () {
				this.selectParentTab().getInputElement().focus();
				return this;
			},
			registerEvents : function (W) {
				var X = /^on([A-Z]\w+)/,
				Y,
				Z = function (ab, ac, ad, ae) {
					ac.on('load', function () {
						ab.getInputElement().on(ad, ae, ab);
					});
				};
				for (var aa in W) {
					if (!(Y = aa.match(X)))
						continue;
					if (this.eventProcessors[aa])
						this.eventProcessors[aa].call(this, this._.dialog, W[aa]);
					else
						Z(this, this._.dialog, Y[1].toLowerCase(), W[aa]);
				}
				return this;
			},
			eventProcessors : {
				onLoad : function (W, X) {
					W.on('load', X, this);
				},
				onShow : function (W, X) {
					W.on('show', X, this);
				},
				onHide : function (W, X) {
					W.on('hide', X, this);
				}
			},
			accessKeyDown : function (W, X) {
				this.focus();
			},
			accessKeyUp : function (W, X) {},
			disable : function () {
				var W = this.getElement(),
				X = this.getInputElement();
				X.setAttribute('disabled', 'true');
				W.addClass('cke_disabled');
			},
			enable : function () {
				var W = this.getElement(),
				X = this.getInputElement();
				X.removeAttribute('disabled');
				W.removeClass('cke_disabled');
			},
			isEnabled : function () {
				return !this.getElement().hasClass('cke_disabled');
			},
			isVisible : function () {
				return this.getInputElement().isVisible();
			},
			isFocusable : function () {
				if (!this.isEnabled() || !this.isVisible())
					return false;
				return true;
			}
		};
		p.dialog.hbox.prototype = j.extend(new p.dialog.uiElement(), {
				getChild : function (W) {
					var X = this;
					if (arguments.length < 1)
						return X._.children.concat();
					if (!W.splice)
						W = [W];
					if (W.length < 2)
						return X._.children[W[0]];
					else
						return X._.children[W[0]] && X._.children[W[0]].getChild ? X._.children[W[0]].getChild(W.slice(1, W.length)) : null;
				}
			}, true);
		p.dialog.vbox.prototype = new p.dialog.hbox();
		(function () {
			var W = {
				build : function (X, Y, Z) {
					var aa = Y.children,
					ab,
					ac = [],
					ad = [];
					for (var ae = 0; ae < aa.length && (ab = aa[ae]); ae++) {
						var af = [];
						ac.push(af);
						ad.push(f.dialog._.uiElementBuilders[ab.type].build(X, ab, af));
					}
					return new p.dialog[Y.type](X, ad, ac, Z, Y);
				}
			};
			f.dialog.addUIElement('hbox', W);
			f.dialog.addUIElement('vbox', W);
		})();
		f.dialogCommand = function (W) {
			this.dialogName = W;
		};
		f.dialogCommand.prototype = {
			exec : function (W) {
				g.opera ? j.setTimeout(function () {
					W.openDialog(this.dialogName);
				}, 0, this) : W.openDialog(this.dialogName);
			},
			canUndo : false,
			editorFocus : h || g.webkit
		};
		(function () {
			var W = /^([a]|[^a])+$/,
			X = /^\d*$/,
			Y = /^\d*(?:\.\d+)?$/,
			Z = /^(((\d*(\.\d+))|(\d*))(px|\%)?)?$/,
			aa = /^(((\d*(\.\d+))|(\d*))(px|em|ex|in|cm|mm|pt|pc|\%)?)?$/i,
			ab = /^(\s*[\w-]+\s*:\s*[^:;]+(?:;|$))*$/;
			f.VALIDATE_OR = 1;
			f.VALIDATE_AND = 2;
			f.dialog.validate = {
				functions : function () {
					var ac = arguments;
					return function () {
						var ad = this && this.getValue ? this.getValue() : ac[0],
						ae = undefined,
						af = 2,
						ag = [],
						ah;
						for (ah = 0; ah < ac.length; ah++) {
							if (typeof ac[ah] == 'function')
								ag.push(ac[ah]);
							else
								break;
						}
						if (ah < ac.length && typeof ac[ah] == 'string') {
							ae = ac[ah];
							ah++;
						}
						if (ah < ac.length && typeof ac[ah] == 'number')
							af = ac[ah];
						var ai = af == 2 ? true : false;
						for (ah = 0; ah < ag.length; ah++) {
							if (af == 2)
								ai = ai && ag[ah](ad);
							else
								ai = ai || ag[ah](ad);
						}
						return !ai ? ae : true;
					};
				},
				regex : function (ac, ad) {
					return function () {
						var ae = this && this.getValue ? this.getValue() : arguments[0];
						return !ac.test(ae) ? ad : true;
					};
				},
				notEmpty : function (ac) {
					return this.regex(W, ac);
				},
				integer : function (ac) {
					return this.regex(X, ac);
				},
				number : function (ac) {
					return this.regex(Y, ac);
				},
				cssLength : function (ac) {
					return this.functions(function (ad) {
						return aa.test(j.trim(ad));
					}, ac);
				},
				htmlLength : function (ac) {
					return this.functions(function (ad) {
						return Z.test(j.trim(ad));
					}, ac);
				},
				inlineStyle : function (ac) {
					return this.functions(function (ad) {
						return ab.test(j.trim(ad));
					}, ac);
				},
				equals : function (ac, ad) {
					return this.functions(function (ae) {
						return ae == ac;
					}, ad);
				},
				notEqual : function (ac, ad) {
					return this.functions(function (ae) {
						return ae != ac;
					}, ad);
				}
			};
			f.on('instanceDestroyed', function (ac) {
				if (j.isEmpty(f.instances)) {
					var ad;
					while (ad = f.dialog._.currentTop)
						ad.hide();
					O();
				}
				var ae = ac.editor._.storedDialogs;
				for (var af in ae)
					ae[af].destroy();
			});
		})();
		j.extend(f.editor.prototype, {
			openDialog : function (W, X) {
				if (this.mode == 'wysiwyg' && h) {
					var Y = this.getSelection();
					Y && Y.lock();
				}
				var Z = f.dialog._.dialogDefinitions[W],
				aa = this.skin.dialog;
				if (f.dialog._.currentTop === null)
					M(this);
				if (typeof Z == 'function' && aa._isLoaded) {
					var ab = this._.storedDialogs || (this._.storedDialogs = {}),
					ac = ab[W] || (ab[W] = new f.dialog(this, W));
					X && X.call(ac, ac);
					ac.show();
					return ac;
				} else if (Z == 'failed') {
					N();
					throw new Error('[CKEDITOR.dialog.openDialog] Dialog "' + W + '" failed when loading definition.');
				}
				var ad = this;
				function ae(ag) {
					var ah = f.dialog._.dialogDefinitions[W],
					ai = ad.skin.dialog;
					if (!ai._isLoaded || af && typeof ag == 'undefined')
						return;
					if (typeof ah != 'function')
						f.dialog._.dialogDefinitions[W] = 'failed';
					ad.openDialog(W, X);
				};
				if (typeof Z == 'string') {
					var af = 1;
					f.scriptLoader.load(f.getUrl(Z), ae, null, 0, 1);
				}
				f.skins.load(this, 'dialog', ae);
				return null;
			}
		});
	})();
	o.add('dialog', {
		requires : ['dialogui']
	});
	o.add('styles', {
		requires : ['selection'],
		init : function (r) {
			r.on('contentDom', function () {
				r.document.setCustomData('cke_includeReadonly', !r.config.disableReadonlyStyling);
			});
		}
	});
	f.editor.prototype.attachStyleStateChange = function (r, s) {
		var t = this._.styleStateChangeCallbacks;
		if (!t) {
			t = this._.styleStateChangeCallbacks = [];
			this.on('selectionChange', function (u) {
				for (var v = 0; v < t.length; v++) {
					var w = t[v],
					x = w.style.checkActive(u.data.path) ? 1 : 2;
					w.fn.call(this, x);
				}
			});
		}
		t.push({
			style : r,
			fn : s
		});
	};
	f.STYLE_BLOCK = 1;
	f.STYLE_INLINE = 2;
	f.STYLE_OBJECT = 3;
	(function () {
		var r = {
			address : 1,
			div : 1,
			h1 : 1,
			h2 : 1,
			h3 : 1,
			h4 : 1,
			h5 : 1,
			h6 : 1,
			p : 1,
			pre : 1,
			section : 1,
			header : 1,
			footer : 1,
			nav : 1,
			article : 1,
			aside : 1,
			figure : 1,
			dialog : 1,
			hgroup : 1,
			time : 1,
			meter : 1,
			menu : 1,
			command : 1,
			keygen : 1,
			output : 1,
			progress : 1,
			details : 1,
			datagrid : 1,
			datalist : 1
		},
		s = {
			a : 1,
			embed : 1,
			hr : 1,
			img : 1,
			li : 1,
			object : 1,
			ol : 1,
			table : 1,
			td : 1,
			tr : 1,
			th : 1,
			ul : 1,
			dl : 1,
			dt : 1,
			dd : 1,
			form : 1,
			audio : 1,
			video : 1
		},
		t = /\s*(?:;\s*|$)/,
		u = /#\((.+?)\)/g,
		v = i.walker.bookmark(0, 1),
		w = i.walker.whitespaces(1);
		f.style = function (Y, Z) {
			var ac = this;
			var aa = Y.attributes;
			if (aa && aa.style) {
				Y.styles = j.extend({}, Y.styles, V(aa.style));
				delete aa.style;
			}
			if (Z) {
				Y = j.clone(Y);
				Q(Y.attributes, Z);
				Q(Y.styles, Z);
			}
			var ab = ac.element = Y.element ? typeof Y.element == 'string' ? Y.element.toLowerCase() : Y.element : '*';
			ac.type = r[ab] ? 1 : s[ab] ? 3 : 2;
			if (typeof ac.element == 'object')
				ac.type = 3;
			ac._ = {
				definition : Y
			};
		};
		f.style.prototype = {
			apply : function (Y) {
				X.call(this, Y, false);
			},
			remove : function (Y) {
				X.call(this, Y, true);
			},
			applyToRange : function (Y) {
				var Z = this;
				return (Z.applyToRange = Z.type == 2 ? y : Z.type == 1 ? C : Z.type == 3 ? A : null).call(Z, Y);
			},
			removeFromRange : function (Y) {
				var Z = this;
				return (Z.removeFromRange = Z.type == 2 ? z : Z.type == 1 ? D : Z.type == 3 ? B : null).call(Z, Y);
			},
			applyToObject : function (Y) {
				P(Y, this);
			},
			checkActive : function (Y) {
				var ad = this;
				switch (ad.type) {
				case 1:
					return ad.checkElementRemovable(Y.block || Y.blockLimit, true);
				case 3:
				case 2:
					var Z = Y.elements;
					for (var aa = 0, ab; aa < Z.length; aa++) {
						ab = Z[aa];
						if (ad.type == 2 && (ab == Y.block || ab == Y.blockLimit))
							continue;
						if (ad.type == 3) {
							var ac = ab.getName();
							if (!(typeof ad.element == 'string' ? ac == ad.element : ac in ad.element))
								continue;
						}
						if (ad.checkElementRemovable(ab, true))
							return true;
					}
				}
				return false;
			},
			checkApplicable : function (Y) {
				switch (this.type) {
				case 2:
				case 1:
					break;
				case 3:
					return Y.lastElement.getAscendant(this.element, true);
				}
				return true;
			},
			checkElementMatch : function (Y, Z) {
				var af = this;
				var aa = af._.definition;
				if (!Y || !aa.ignoreReadonly && Y.isReadOnly())
					return false;
				var ab,
				ac = Y.getName();
				if (typeof af.element == 'string' ? ac == af.element : ac in af.element) {
					if (!Z && !Y.hasAttributes())
						return true;
					ab = R(aa);
					if (ab._length) {
						for (var ad in ab) {
							if (ad == '_length')
								continue;
							var ae = Y.getAttribute(ad) || '';
							if (ad == 'style' ? W(ab[ad], U(ae, false)) : ab[ad] == ae) {
								if (!Z)
									return true;
							} else if (Z)
								return false;
						}
						if (Z)
							return true;
					} else
						return true;
				}
				return false;
			},
			checkElementRemovable : function (Y, Z) {
				if (this.checkElementMatch(Y, Z))
					return true;
				var aa = S(this)[Y.getName()];
				if (aa) {
					var ab,
					ac;
					if (!(ab = aa.attributes))
						return true;
					for (var ad = 0; ad < ab.length; ad++) {
						ac = ab[ad][0];
						var ae = Y.getAttribute(ac);
						if (ae) {
							var af = ab[ad][1];
							if (af === null || typeof af == 'string' && ae == af || af.test(ae))
								return true;
						}
					}
				}
				return false;
			},
			buildPreview : function (Y) {
				var Z = this._.definition,
				aa = [],
				ab = Z.element;
				if (ab == 'bdo')
					ab = 'span';
				aa = ['<', ab];
				var ac = Z.attributes;
				if (ac)
					for (var ad in ac)
						aa.push(' ', ad, '="', ac[ad], '"');
				var ae = f.style.getStyleText(Z);
				if (ae)
					aa.push(' style="', ae, '"');
				aa.push('>', Y || Z.name, '</', ab, '>');
				return aa.join('');
			}
		};
		f.style.getStyleText = function (Y) {
			var Z = Y._ST;
			if (Z)
				return Z;
			Z = Y.styles;
			var aa = Y.attributes && Y.attributes.style || '',
			ab = '';
			if (aa.length)
				aa = aa.replace(t, ';');
			for (var ac in Z) {
				var ad = Z[ac],
				ae = (ac + ':' + ad).replace(t, ';');
				if (ad == 'inherit')
					ab += ae;
				else
					aa += ae;
			}
			if (aa.length)
				aa = U(aa);
			aa += ab;
			return Y._ST = aa;
		};
		function x(Y) {
			var Z,
			aa;
			while (Y = Y.getParent()) {
				if (Y.getName() == 'body')
					break;
				if (Y.getAttribute('data-nostyle'))
					Z = Y;
				else if (!aa) {
					var ab = Y.getAttribute('contentEditable');
					if (ab == 'false')
						Z = Y;
					else if (ab == 'true')
						aa = 1;
				}
			}
			return Z;
		};
		function y(Y) {
			var aD = this;
			var Z = Y.document;
			if (Y.collapsed) {
				var aa = O(aD, Z);
				Y.insertNode(aa);
				Y.moveToPosition(aa, 2);
				return;
			}
			var ab = aD.element,
			ac = aD._.definition,
			ad,
			ae = ac.ignoreReadonly,
			af = ae || ac.includeReadonly;
			if (af == undefined)
				af = Z.getCustomData('cke_includeReadonly');
			var ag = k[ab] || (ad = true, k.span);
			Y.enlarge(1, 1);
			Y.trim();
			var ah = Y.createBookmark(),
			ai = ah.startNode,
			aj = ah.endNode,
			ak = ai,
			al;
			if (!ae) {
				var am = x(ai),
				an = x(aj);
				if (am)
					ak = am.getNextSourceNode(true);
				if (an)
					aj = an;
			}
			if (ak.getPosition(aj) == 2)
				ak = 0;
			while (ak) {
				var ao = false;
				if (ak.equals(aj)) {
					ak = null;
					ao = true;
				} else {
					var ap = ak.type,
					aq = ap == 1 ? ak.getName() : null,
					ar = aq && ak.getAttribute('contentEditable') == 'false',
					as = aq && ak.getAttribute('data-nostyle');
					if (aq && ak.data('cke-bookmark')) {
						ak = ak.getNextSourceNode(true);
						continue;
					}
					if (!aq || ag[aq] && !as && (!ar || af) && (ak.getPosition(aj) | 4 | 0 | 8) == 4 + 0 + 8 && (!ac.childRule || ac.childRule(ak))) {
						var at = ak.getParent();
						if (at && ((at.getDtd() || k.span)[ab] || ad) && (!ac.parentRule || ac.parentRule(at))) {
							if (!al && (!aq || !k.$removeEmpty[aq] || (ak.getPosition(aj) | 4 | 0 | 8) == 4 + 0 + 8)) {
								al = new i.range(Z);
								al.setStartBefore(ak);
							}
							if (ap == 3 || ar || ap == 1 && !ak.getChildCount()) {
								var au = ak,
								av;
								while ((ao = !au.getNext(v)) && (av = au.getParent(), ag[av.getName()]) && (av.getPosition(ai) | 2 | 0 | 8) == 2 + 0 + 8 && (!ac.childRule || ac.childRule(av)))
									au = av;
								al.setEndAfter(au);
							}
						} else
							ao = true;
					} else
						ao = true;
					ak = ak.getNextSourceNode(as || ar);
				}
				if (ao && al && !al.collapsed) {
					var aw = O(aD, Z),
					ax = aw.hasAttributes(),
					ay = al.getCommonAncestor(),
					az = {
						styles : {},
						attrs : {},
						blockedStyles : {},
						blockedAttrs : {}
						
					},
					aA,
					aB,
					aC;
					while (aw && ay) {
						if (ay.getName() == ab) {
							for (aA in ac.attributes) {
								if (az.blockedAttrs[aA] || !(aC = ay.getAttribute(aB)))
									continue;
								if (aw.getAttribute(aA) == aC)
									az.attrs[aA] = 1;
								else
									az.blockedAttrs[aA] = 1;
							}
							for (aB in ac.styles) {
								if (az.blockedStyles[aB] || !(aC = ay.getStyle(aB)))
									continue;
								if (aw.getStyle(aB) == aC)
									az.styles[aB] = 1;
								else
									az.blockedStyles[aB] = 1;
							}
						}
						ay = ay.getParent();
					}
					for (aA in az.attrs)
						aw.removeAttribute(aA);
					for (aB in az.styles)
						aw.removeStyle(aB);
					if (ax && !aw.hasAttributes())
						aw = null;
					if (aw) {
						al.extractContents().appendTo(aw);
						L(aD, aw);
						al.insertNode(aw);
						aw.mergeSiblings();
						if (!h)
							aw.$.normalize();
					} else {
						aw = new m('span');
						al.extractContents().appendTo(aw);
						al.insertNode(aw);
						L(aD, aw);
						aw.remove(true);
					}
					al = null;
				}
			}
			Y.moveToBookmark(ah);
			Y.shrink(2);
		};
		function z(Y) {
			Y.enlarge(1, 1);
			var Z = Y.createBookmark(),
			aa = Z.startNode;
			if (Y.collapsed) {
				var ab = new i.elementPath(aa.getParent()),
				ac;
				for (var ad = 0, ae; ad < ab.elements.length && (ae = ab.elements[ad]); ad++) {
					if (ae == ab.block || ae == ab.blockLimit)
						break;
					if (this.checkElementRemovable(ae)) {
						var af;
						if (Y.collapsed && (Y.checkBoundaryOfElement(ae, 2) || (af = Y.checkBoundaryOfElement(ae, 1)))) {
							ac = ae;
							ac.match = af ? 'start' : 'end';
						} else {
							ae.mergeSiblings();
							if (ae.getName() == this.element)
								K(this, ae);
							else
								M(ae, S(this)[ae.getName()]);
						}
					}
				}
				if (ac) {
					var ag = aa;
					for (ad = 0; true; ad++) {
						var ah = ab.elements[ad];
						if (ah.equals(ac))
							break;
						else if (ah.match)
							continue;
						else
							ah = ah.clone();
						ah.append(ag);
						ag = ah;
					}
					ag[ac.match == 'start' ? 'insertBefore' : 'insertAfter'](ac);
				}
			} else {
				var ai = Z.endNode,
				aj = this;
				function ak() {
					var an = new i.elementPath(aa.getParent()),
					ao = new i.elementPath(ai.getParent()),
					ap = null,
					aq = null;
					for (var ar = 0; ar < an.elements.length; ar++) {
						var as = an.elements[ar];
						if (as == an.block || as == an.blockLimit)
							break;
						if (aj.checkElementRemovable(as))
							ap = as;
					}
					for (ar = 0; ar < ao.elements.length; ar++) {
						as = ao.elements[ar];
						if (as == ao.block || as == ao.blockLimit)
							break;
						if (aj.checkElementRemovable(as))
							aq = as;
					}
					if (aq)
						ai.breakParent(aq);
					if (ap)
						aa.breakParent(ap);
				};
				ak();
				var al = aa;
				while (!al.equals(ai)) {
					var am = al.getNextSourceNode();
					if (al.type == 1 && this.checkElementRemovable(al)) {
						if (al.getName() == this.element)
							K(this, al);
						else
							M(al, S(this)[al.getName()]);
						if (am.type == 1 && am.contains(aa)) {
							ak();
							am = aa.getNext();
						}
					}
					al = am;
				}
			}
			Y.moveToBookmark(Z);
		};
		function A(Y) {
			var Z = Y.getCommonAncestor(true, true),
			aa = Z.getAscendant(this.element, true);
			aa && !aa.isReadOnly() && P(aa, this);
		};
		function B(Y) {
			var Z = Y.getCommonAncestor(true, true),
			aa = Z.getAscendant(this.element, true);
			if (!aa)
				return;
			var ab = this,
			ac = ab._.definition,
			ad = ac.attributes;
			if (ad)
				for (var ae in ad)
					aa.removeAttribute(ae, ad[ae]);
			if (ac.styles)
				for (var af in ac.styles) {
					if (!ac.styles.hasOwnProperty(af))
						continue;
					aa.removeStyle(af);
				}
		};
		function C(Y) {
			var Z = Y.createBookmark(true),
			aa = Y.createIterator();
			aa.enforceRealBlocks = true;
			if (this._.enterMode)
				aa.enlargeBr = this._.enterMode != 2;
			var ab,
			ac = Y.document,
			ad;
			while (ab = aa.getNextParagraph()) {
				if (!ab.isReadOnly()) {
					var ae = O(this, ac, ab);
					E(ab, ae);
				}
			}
			Y.moveToBookmark(Z);
		};
		function D(Y) {
			var ad = this;
			var Z = Y.createBookmark(1),
			aa = Y.createIterator();
			aa.enforceRealBlocks = true;
			aa.enlargeBr = ad._.enterMode != 2;
			var ab;
			while (ab = aa.getNextParagraph()) {
				if (ad.checkElementRemovable(ab))
					if (ab.is('pre')) {
						var ac = ad._.enterMode == 2 ? null : Y.document.createElement(ad._.enterMode == 1 ? 'p' : 'div');
						ac && ab.copyAttributes(ac);
						E(ab, ac);
					} else
						K(ad, ab, 1);
			}
			Y.moveToBookmark(Z);
		};
		function E(Y, Z) {
			var aa = !Z;
			if (aa) {
				Z = Y.getDocument().createElement('div');
				Y.copyAttributes(Z);
			}
			var ab = Z && Z.is('pre'),
			ac = Y.is('pre'),
			ad = ab && !ac,
			ae = !ab && ac;
			if (ad)
				Z = J(Y, Z);
			else if (ae)
				Z = I(aa ? [Y.getHtml()] : G(Y), Z);
			else
				Y.moveChildren(Z);
			Z.replace(Y);
			if (ab)
				F(Z);
			else if (aa)
				N(Z);
		};
		function F(Y) {
			var Z;
			if (!((Z = Y.getPrevious(w)) && Z.is && Z.is('pre')))
				return;
			var aa = H(Z.getHtml(), /\n$/, '') + '\n\n' + H(Y.getHtml(), /^\n/, '');
			if (h)
				Y.$.outerHTML = '<pre>' + aa + '</pre>';
			else
				Y.setHtml(aa);
			Z.remove();
		};
		function G(Y) {
			var Z = /(\S\s*)\n(?:\s|(<span[^>]+data-cke-bookmark.*?\/span>))*\n(?!$)/gi,
			aa = Y.getName(),
			ab = H(Y.getOuterHtml(), Z, function (ad, ae, af) {
					return ae + '</pre>' + af + '<pre>';
				}),
			ac = [];
			ab.replace(/<pre\b.*?>([\s\S]*?)<\/pre>/gi, function (ad, ae) {
				ac.push(ae);
			});
			return ac;
		};
		function H(Y, Z, aa) {
			var ab = '',
			ac = '';
			Y = Y.replace(/(^<span[^>]+data-cke-bookmark.*?\/span>)|(<span[^>]+data-cke-bookmark.*?\/span>$)/gi, function (ad, ae, af) {
					ae && (ab = ae);
					af && (ac = af);
					return '';
				});
			return ab + Y.replace(Z, aa) + ac;
		};
		function I(Y, Z) {
			var aa;
			if (Y.length > 1)
				aa = new i.documentFragment(Z.getDocument());
			for (var ab = 0; ab < Y.length; ab++) {
				var ac = Y[ab];
				ac = ac.replace(/(\r\n|\r)/g, '\n');
				ac = H(ac, /^[ \t]*\n/, '');
				ac = H(ac, /\n$/, '');
				ac = H(ac, /^[ \t]+|[ \t]+$/g, function (ae, af, ag) {
						if (ae.length == 1)
							return '&nbsp;';
						else if (!af)
							return j.repeat('&nbsp;', ae.length - 1) + ' ';
						else
							return ' ' + j.repeat('&nbsp;', ae.length - 1);
					});
				ac = ac.replace(/\n/g, '<br>');
				ac = ac.replace(/[ \t]{2,}/g, function (ae) {
						return j.repeat('&nbsp;', ae.length - 1) + ' ';
					});
				if (aa) {
					var ad = Z.clone();
					ad.setHtml(ac);
					aa.append(ad);
				} else
					Z.setHtml(ac);
			}
			return aa || Z;
		};
		function J(Y, Z) {
			var aa = Y.getBogus();
			aa && aa.remove();
			var ab = Y.getHtml();
			ab = H(ab, /(?:^[ \t\n\r]+)|(?:[ \t\n\r]+$)/g, '');
			ab = ab.replace(/[ \t\r\n]*(<br[^>]*>)[ \t\r\n]*/gi, '$1');
			ab = ab.replace(/([ \t\n\r]+|&nbsp;)/g, ' ');
			ab = ab.replace(/<br\b[^>]*>/gi, '\n');
			if (h) {
				var ac = Y.getDocument().createElement('div');
				ac.append(Z);
				Z.$.outerHTML = '<pre>' + ab + '</pre>';
				Z.copyAttributes(ac.getFirst());
				Z = ac.getFirst().remove();
			} else
				Z.setHtml(ab);
			return Z;
		};
		function K(Y, Z) {
			var aa = Y._.definition,
			ab = aa.attributes,
			ac = aa.styles,
			ad = S(Y)[Z.getName()],
			ae = j.isEmpty(ab) && j.isEmpty(ac);
			for (var af in ab) {
				if ((af == 'class' || Y._.definition.fullMatch) && Z.getAttribute(af) != T(af, ab[af]))
					continue;
				ae = Z.hasAttribute(af);
				Z.removeAttribute(af);
			}
			for (var ag in ac) {
				if (Y._.definition.fullMatch && Z.getStyle(ag) != T(ag, ac[ag], true))
					continue;
				ae = ae || !!Z.getStyle(ag);
				Z.removeStyle(ag);
			}
			M(Z, ad, r[Z.getName()]);
			if (ae)
				!k.$block[Z.getName()] || Y._.enterMode == 2 && !Z.hasAttributes() ? N(Z) : Z.renameNode(Y._.enterMode == 1 ? 'p' : 'div');
		};
		function L(Y, Z) {
			var aa = Y._.definition,
			ab = aa.attributes,
			ac = aa.styles,
			ad = S(Y),
			ae = Z.getElementsByTag(Y.element);
			for (var af = ae.count(); --af >= 0; )
				K(Y, ae.getItem(af));
			for (var ag in ad) {
				if (ag != Y.element) {
					ae = Z.getElementsByTag(ag);
					for (af = ae.count() - 1; af >= 0; af--) {
						var ah = ae.getItem(af);
						M(ah, ad[ag]);
					}
				}
			}
		};
		function M(Y, Z, aa) {
			var ab = Z && Z.attributes;
			if (ab)
				for (var ac = 0; ac < ab.length; ac++) {
					var ad = ab[ac][0],
					ae;
					if (ae = Y.getAttribute(ad)) {
						var af = ab[ac][1];
						if (af === null || af.test && af.test(ae) || typeof af == 'string' && ae == af)
							Y.removeAttribute(ad);
					}
				}
			if (!aa)
				N(Y);
		};
		function N(Y) {
			if (!Y.hasAttributes())
				if (k.$block[Y.getName()]) {
					var Z = Y.getPrevious(w),
					aa = Y.getNext(w);
					if (Z && (Z.type == 3 || !Z.isBlockBoundary({
								br : 1
							})))
						Y.append('br', 1);
					if (aa && (aa.type == 3 || !aa.isBlockBoundary({
								br : 1
							})))
						Y.append('br');
					Y.remove(true);
				} else {
					var ab = Y.getFirst(),
					ac = Y.getLast();
					Y.remove(true);
					if (ab) {
						ab.type == 1 && ab.mergeSiblings();
						if (ac && !ab.equals(ac) && ac.type == 1)
							ac.mergeSiblings();
					}
				}
		};
		function O(Y, Z, aa) {
			var ab,
			ac = Y._.definition,
			ad = Y.element;
			if (ad == '*')
				ad = 'span';
			ab = new m(ad, Z);
			if (aa)
				aa.copyAttributes(ab);
			ab = P(ab, Y);
			if (Z.getCustomData('doc_processing_style') && ab.hasAttribute('id'))
				ab.removeAttribute('id');
			else
				Z.setCustomData('doc_processing_style', 1);
			return ab;
		};
		function P(Y, Z) {
			var aa = Z._.definition,
			ab = aa.attributes,
			ac = f.style.getStyleText(aa);
			if (ab)
				for (var ad in ab)
					Y.setAttribute(ad, ab[ad]);
			if (ac)
				Y.setAttribute('style', ac);
			return Y;
		};
		function Q(Y, Z) {
			for (var aa in Y)
				Y[aa] = Y[aa].replace(u, function (ab, ac) {
						return Z[ac];
					});
		};
		function R(Y) {
			var Z = Y._AC;
			if (Z)
				return Z;
			Z = {};
			var aa = 0,
			ab = Y.attributes;
			if (ab)
				for (var ac in ab) {
					aa++;
					Z[ac] = ab[ac];
				}
			var ad = f.style.getStyleText(Y);
			if (ad) {
				if (!Z.style)
					aa++;
				Z.style = ad;
			}
			Z._length = aa;
			return Y._AC = Z;
		};
		function S(Y) {
			if (Y._.overrides)
				return Y._.overrides;
			var Z = Y._.overrides = {},
			aa = Y._.definition.overrides;
			if (aa) {
				if (!j.isArray(aa))
					aa = [aa];
				for (var ab = 0; ab < aa.length; ab++) {
					var ac = aa[ab],
					ad,
					ae,
					af;
					if (typeof ac == 'string')
						ad = ac.toLowerCase();
					else {
						ad = ac.element ? ac.element.toLowerCase() : Y.element;
						af = ac.attributes;
					}
					ae = Z[ad] || (Z[ad] = {});
					if (af) {
						var ag = ae.attributes = ae.attributes || [];
						for (var ah in af)
							ag.push([ah.toLowerCase(), af[ah]]);
					}
				}
			}
			return Z;
		};
		function T(Y, Z, aa) {
			var ab = new m('span');
			ab[aa ? 'setStyle' : 'setAttribute'](Y, Z);
			return ab[aa ? 'getStyle' : 'getAttribute'](Y);
		};
		function U(Y, Z) {
			var aa;
			if (Z !== false) {
				var ab = new m('span');
				ab.setAttribute('style', Y);
				aa = ab.getAttribute('style') || '';
			} else
				aa = Y;
			aa = aa.replace(/(font-family:)(.*?)(?=;|$)/, function (ac, ad, ae) {
					var af = ae.split(',');
					for (var ag = 0; ag < af.length; ag++)
						af[ag] = j.trim(af[ag].replace(/["']/g, ''));
					return ad + af.join(',');
				});
			return aa.replace(/\s*([;:])\s*/, '$1').replace(/([^\s;])$/, '$1;').replace(/,\s+/g, ',').replace(/\"/g, '').toLowerCase();
		};
		function V(Y) {
			var Z = {};
			Y.replace(/&quot;/g, '"').replace(/\s*([^ :;]+)\s*:\s*([^;]+)\s*(?=;|$)/g, function (aa, ab, ac) {
				Z[ab] = ac;
			});
			return Z;
		};
		function W(Y, Z) {
			typeof Y == 'string' && (Y = V(Y));
			typeof Z == 'string' && (Z = V(Z));
			for (var aa in Y) {
				if (!(aa in Z && (Z[aa] == Y[aa] || Y[aa] == 'inherit' || Z[aa] == 'inherit')))
					return false;
			}
			return true;
		};
		function X(Y, Z) {
			var aa = Y.getSelection(),
			ab = aa.createBookmarks(1),
			ac = aa.getRanges(),
			ad = Z ? this.removeFromRange : this.applyToRange,
			ae,
			af = ac.createIterator();
			while (ae = af.getNextRange())
				ad.call(this, ae);
			if (ab.length == 1 && ab[0].collapsed) {
				aa.selectRanges(ac);
				Y.getById(ab[0].startNode).remove();
			} else
				aa.selectBookmarks(ab);
			Y.removeCustomData('doc_processing_style');
		};
	})();
	f.styleCommand = function (r) {
		this.style = r;
	};
	f.styleCommand.prototype.exec = function (r) {
		var t = this;
		r.focus();
		var s = r.document;
		if (s)
			if (t.state == 2)
				t.style.apply(s);
			else if (t.state == 1)
				t.style.remove(s);
		return !!s;
	};
	f.stylesSet = new f.resourceManager('', 'stylesSet');
	f.addStylesSet = j.bind(f.stylesSet.add, f.stylesSet);
	f.loadStylesSet = function (r, s, t) {
		f.stylesSet.addExternal(r, s, '');
		f.stylesSet.load(r, t);
	};
	f.editor.prototype.getStylesSet = function (r) {
		if (!this._.stylesDefinitions) {
			var s = this,
			t = s.config.stylesCombo_stylesSet || s.config.stylesSet || 'default';
			if (t instanceof Array) {
				s._.stylesDefinitions = t;
				r(t);
				return;
			}
			var u = t.split(':'),
			v = u[0],
			w = u[1],
			x = o.registered.styles.path;
			f.stylesSet.addExternal(v, w ? u.slice(1).join(':') : x + 'styles/' + v + '.js', '');
			f.stylesSet.load(v, function (y) {
				s._.stylesDefinitions = y[v];
				r(s._.stylesDefinitions);
			});
		} else
			r(this._.stylesDefinitions);
	};
	o.add('domiterator');
	(function () {
		function r(x) {
			var y = this;
			if (arguments.length < 1)
				return;
			y.range = x;
			y.forceBrBreak = 0;
			y.enlargeBr = 1;
			y.enforceRealBlocks = 0;
			y._ || (y._ = {});
		};
		var s = /^[\r\n\t ]+$/,
		t = i.walker.bookmark(false, true),
		u = i.walker.whitespaces(true),
		v = function (x) {
			return t(x) && u(x);
		};
		function w(x, y, z) {
			var A = x.getNextSourceNode(y, null, z);
			while (!t(A))
				A = A.getNextSourceNode(y, null, z);
			return A;
		};
		r.prototype = {
			getNextParagraph : function (x) {
				var X = this;
				var y,
				z,
				A,
				B,
				C,
				D;
				if (!X._.started) {
					z = X.range.clone();
					z.shrink(1, true);
					B = z.endContainer.hasAscendant('pre', true) || z.startContainer.hasAscendant('pre', true);
					z.enlarge(X.forceBrBreak && !B || !X.enlargeBr ? 3 : 2);
					if (!z.collapsed) {
						var E = new i.walker(z.clone()),
						F = i.walker.bookmark(true, true);
						E.evaluator = F;
						X._.nextNode = E.next();
						E = new i.walker(z.clone());
						E.evaluator = F;
						var G = E.previous();
						X._.lastNode = G.getNextSourceNode(true);
						if (X._.lastNode && X._.lastNode.type == 3 && !j.trim(X._.lastNode.getText()) && X._.lastNode.getParent().isBlockBoundary()) {
							var H = new i.range(z.document);
							H.moveToPosition(X._.lastNode, 4);
							if (H.checkEndOfBlock()) {
								var I = new i.elementPath(H.endContainer),
								J = I.block || I.blockLimit;
								X._.lastNode = J.getNextSourceNode(true);
							}
						}
						if (!X._.lastNode) {
							X._.lastNode = X._.docEndMarker = z.document.createText('');
							X._.lastNode.insertAfter(G);
						}
						z = null;
					}
					X._.started = 1;
				}
				var K = X._.nextNode;
				G = X._.lastNode;
				X._.nextNode = null;
				while (K) {
					var L = 0,
					M = K.hasAscendant('pre'),
					N = K.type != 1,
					O = 0;
					if (!N) {
						var P = K.getName();
						if (K.isBlockBoundary(X.forceBrBreak && !M && {
								br : 1
							})) {
							if (P == 'br')
								N = 1;
							else if (!z && !K.getChildCount() && P != 'hr') {
								y = K;
								A = K.equals(G);
								break;
							}
							if (z) {
								z.setEndAt(K, 3);
								if (P != 'br')
									X._.nextNode = K;
							}
							L = 1;
						} else {
							if (K.getFirst()) {
								if (!z) {
									z = new i.range(X.range.document);
									z.setStartAt(K, 3);
								}
								K = K.getFirst();
								continue;
							}
							N = 1;
						}
					} else if (K.type == 3)
						if (s.test(K.getText()))
							N = 0;
					if (N && !z) {
						z = new i.range(X.range.document);
						z.setStartAt(K, 3);
					}
					A = (!L || N) && K.equals(G);
					if (z && !L)
						while (!K.getNext(v) && !A) {
							var Q = K.getParent();
							if (Q.isBlockBoundary(X.forceBrBreak && !M && {
									br : 1
								})) {
								L = 1;
								N = 0;
								A = A || Q.equals(G);
								z.setEndAt(Q, 2);
								break;
							}
							K = Q;
							N = 1;
							A = K.equals(G);
							O = 1;
						}
					if (N)
						z.setEndAt(K, 4);
					K = w(K, O, G);
					A = !K;
					if (A || L && z)
						break;
				}
				if (!y) {
					if (!z) {
						X._.docEndMarker && X._.docEndMarker.remove();
						X._.nextNode = null;
						return null;
					}
					var R = new i.elementPath(z.startContainer),
					S = R.blockLimit,
					T = {
						div : 1,
						th : 1,
						td : 1
					};
					y = R.block;
					if (!y && !X.enforceRealBlocks && T[S.getName()] && z.checkStartOfBlock() && z.checkEndOfBlock())
						y = S;
					else if (!y || X.enforceRealBlocks && y.getName() == 'li') {
						y = X.range.document.createElement(x || 'p');
						z.extractContents().appendTo(y);
						y.trim();
						z.insertNode(y);
						C = D = true;
					} else if (y.getName() != 'li') {
						if (!z.checkStartOfBlock() || !z.checkEndOfBlock()) {
							y = y.clone(false);
							z.extractContents().appendTo(y);
							y.trim();
							var U = z.splitBlock();
							C = !U.wasStartOfBlock;
							D = !U.wasEndOfBlock;
							z.insertNode(y);
						}
					} else if (!A)
						X._.nextNode = y.equals(G) ? null : w(z.getBoundaryNodes().endNode, 1, G);
				}
				if (C) {
					var V = y.getPrevious();
					if (V && V.type == 1)
						if (V.getName() == 'br')
							V.remove();
						else if (V.getLast() && V.getLast().$.nodeName.toLowerCase() == 'br')
							V.getLast().remove();
				}
				if (D) {
					var W = y.getLast();
					if (W && W.type == 1 && W.getName() == 'br')
						if (h || W.getPrevious(t) || W.getNext(t))
							W.remove();
				}
				if (!X._.nextNode)
					X._.nextNode = A || y.equals(G) || !G ? null : w(y, 1, G);
				return y;
			}
		};
		i.range.prototype.createIterator = function () {
			return new r(this);
		};
	})();
	o.add('panelbutton', {
		requires : ['button'],
		onLoad : function () {
			function r(s) {
				var u = this;
				var t = u._;
				if (t.state == 0)
					return;
				u.createPanel(s);
				if (t.on) {
					t.panel.hide();
					return;
				}
				t.panel.showBlock(u._.id, u.document.getById(u._.id), 4);
			};
			p.panelButton = j.createClass({
					base : p.button,
					$ : function (s) {
						var u = this;
						var t = s.panel;
						delete s.panel;
						u.base(s);
						u.document = t && t.parent && t.parent.getDocument() || f.document;
						t.block = {
							attributes : t.attributes
						};
						u.hasArrow = true;
						u.click = r;
						u._ = {
							panelDefinition : t
						};
					},
					statics : {
						handler : {
							create : function (s) {
								return new p.panelButton(s);
							}
						}
					},
					proto : {
						createPanel : function (s) {
							var t = this._;
							if (t.panel)
								return;
							var u = this._.panelDefinition || {},
							v = this._.panelDefinition.block,
							w = u.parent || f.document.getBody(),
							x = this._.panel = new p.floatPanel(s, w, u),
							y = x.addBlock(t.id, v),
							z = this;
							x.onShow = function () {
								if (z.className)
									this.element.getFirst().addClass(z.className + '_panel');
								z.setState(1);
								t.on = 1;
								if (z.onOpen)
									z.onOpen();
							};
							x.onHide = function (A) {
								if (z.className)
									this.element.getFirst().removeClass(z.className + '_panel');
								z.setState(z.modes && z.modes[s.mode] ? 2 : 0);
								t.on = 0;
								if (!A && z.onClose)
									z.onClose();
							};
							x.onEscape = function () {
								x.hide();
								z.document.getById(t.id).focus();
							};
							if (this.onBlock)
								this.onBlock(x, y);
							y.onHide = function () {
								t.on = 0;
								z.setState(2);
							};
						}
					}
				});
		},
		beforeInit : function (r) {
			r.ui.addHandler(4, p.panelButton.handler);
		}
	});
	f.UI_PANELBUTTON = 'panelbutton';
	o.add('floatpanel', {
		requires : ['panel']
	});
	(function () {
		var r = {},
		s = false;
		function t(u, v, w, x, y) {
			var z = j.genKey(v.getUniqueId(), w.getUniqueId(), u.skinName, u.lang.dir, u.uiColor || '', x.css || '', y || ''),
			A = r[z];
			if (!A) {
				A = r[z] = new p.panel(v, x);
				A.element = w.append(m.createFromHtml(A.renderHtml(u), v));
				A.element.setStyles({
					display : 'none',
					position : 'absolute'
				});
			}
			return A;
		};
		p.floatPanel = j.createClass({
				$ : function (u, v, w, x) {
					w.forceIFrame = 1;
					var y = v.getDocument(),
					z = t(u, y, v, w, x || 0),
					A = z.element,
					B = A.getFirst().getFirst();
					A.disableContextMenu();
					this.element = A;
					this._ = {
						editor : u,
						panel : z,
						parentElement : v,
						definition : w,
						document : y,
						iframe : B,
						children : [],
						dir : u.lang.dir
					};
					u.on('mode', function () {
						this.hide();
					}, this);
				},
				proto : {
					addBlock : function (u, v) {
						return this._.panel.addBlock(u, v);
					},
					addListBlock : function (u, v) {
						return this._.panel.addListBlock(u, v);
					},
					getBlock : function (u) {
						return this._.panel.getBlock(u);
					},
					showBlock : function (u, v, w, x, y) {
						var z = this._.panel,
						A = z.showBlock(u);
						this.allowBlur(false);
						s = 1;
						this._.returnFocus = this._.editor.focusManager.hasFocus ? this._.editor : new m(f.document.$.activeElement);
						var B = this.element,
						C = this._.iframe,
						D = this._.definition,
						E = v.getDocumentPosition(B.getDocument()),
						F = this._.dir == 'rtl',
						G = E.x + (x || 0),
						H = E.y + (y || 0);
						if (F && (w == 1 || w == 4))
							G += v.$.offsetWidth;
						else if (!F && (w == 2 || w == 3))
							G += v.$.offsetWidth - 1;
						if (w == 3 || w == 4)
							H += v.$.offsetHeight - 1;
						this._.panel._.offsetParentId = v.getId();
						B.setStyles({
							top : H + 'px',
							left : 0,
							display : ''
						});
						B.setOpacity(0);
						B.getFirst().removeStyle('width');
						if (!this._.blurSet) {
							var I = h ? C : new i.window(C.$.contentWindow);
							f.event.useCapture = true;
							I.on('blur', function (J) {
								var L = this;
								if (!L.allowBlur())
									return;
								var K = J.data.getTarget();
								if (K.getName && K.getName() != 'iframe')
									return;
								if (L.visible && !L._.activeChild && !s) {
									delete L._.returnFocus;
									L.hide();
								}
							}, this);
							I.on('focus', function () {
								this._.focused = true;
								this.hideChild();
								this.allowBlur(true);
							}, this);
							f.event.useCapture = false;
							this._.blurSet = 1;
						}
						z.onEscape = j.bind(function (J) {
								if (this.onEscape && this.onEscape(J) === false)
									return false;
							}, this);
						j.setTimeout(function () {
							var J = j.bind(function () {
									var K = B.getFirst();
									if (A.autoSize) {
										var L = A.element.getDocument(),
										M = (g.webkit ? A.element : L.getBody()).$.scrollWidth;
										if (h && g.quirks && M > 0)
											M += (K.$.offsetWidth || 0) - (K.$.clientWidth || 0) + 3;
										M += 4;
										K.setStyle('width', M + 'px');
										A.element.addClass('cke_frameLoaded');
										var N = A.element.$.scrollHeight;
										if (h && g.quirks && N > 0)
											N += (K.$.offsetHeight || 0) - (K.$.clientHeight || 0) + 3;
										K.setStyle('height', N + 'px');
										z._.currentBlock.element.setStyle('display', 'none').removeStyle('display');
									} else
										K.removeStyle('height');
									if (F)
										G -= B.$.offsetWidth;
									B.setStyle('left', G + 'px');
									var O = z.element,
									P = O.getWindow(),
									Q = B.$.getBoundingClientRect(),
									R = P.getViewPaneSize(),
									S = Q.width || Q.right - Q.left,
									T = Q.height || Q.bottom - Q.top,
									U = F ? Q.right : R.width - Q.left,
									V = F ? R.width - Q.right : Q.left;
									if (F) {
										if (U < S)
											if (V > S)
												G += S;
											else if (R.width > S)
												G -= Q.left;
											else
												G = G - Q.right + R.width;
									} else if (U < S)
										if (V > S)
											G -= S;
										else if (R.width > S)
											G = G - Q.right + R.width;
										else
											G -= Q.left;
									var W = R.height - Q.top,
									X = Q.top;
									if (W < T)
										if (X > T)
											H -= T;
										else if (R.height > T)
											H = H - Q.bottom + R.height;
										else
											H -= Q.top;
									if (h) {
										var Y = new m(B.$.offsetParent),
										Z = Y;
										if (Z.getName() == 'html')
											Z = Z.getDocument().getBody();
										if (Z.getComputedStyle('direction') == 'rtl')
											if (g.ie8Compat)
												G -= B.getDocument().getDocumentElement().$.scrollLeft * 2;
											else
												G -= Y.$.scrollWidth - Y.$.clientWidth;
									}
									var aa = B.getFirst(),
									ab;
									if (ab = aa.getCustomData('activePanel'))
										ab.onHide && ab.onHide.call(this, 1);
									aa.setCustomData('activePanel', this);
									B.setStyles({
										top : H + 'px',
										left : G + 'px'
									});
									B.setOpacity(1);
								}, this);
							z.isLoaded ? J() : z.onLoad = J;
							j.setTimeout(function () {
								C.$.contentWindow.focus();
								this.allowBlur(true);
							}, 0, this);
						}, g.air ? 200 : 0, this);
						this.visible = 1;
						if (this.onShow)
							this.onShow.call(this);
						s = 0;
					},
					hide : function (u) {
						var w = this;
						if (w.visible && (!w.onHide || w.onHide.call(w) !== true)) {
							w.hideChild();
							g.gecko && w._.iframe.getFrameDocument().$.activeElement.blur();
							w.element.setStyle('display', 'none');
							w.visible = 0;
							w.element.getFirst().removeCustomData('activePanel');
							var v = u !== false && w._.returnFocus;
							if (v) {
								if (g.webkit && v.type)
									v.getWindow().$.focus();
								v.focus();
							}
						}
					},
					allowBlur : function (u) {
						var v = this._.panel;
						if (u != undefined)
							v.allowBlur = u;
						return v.allowBlur;
					},
					showAsChild : function (u, v, w, x, y, z) {
						if (this._.activeChild == u && u._.panel._.offsetParentId == w.getId())
							return;
						this.hideChild();
						u.onHide = j.bind(function () {
								j.setTimeout(function () {
									if (!this._.focused)
										this.hide();
								}, 0, this);
							}, this);
						this._.activeChild = u;
						this._.focused = false;
						u.showBlock(v, w, x, y, z);
						if (g.ie7Compat || g.ie8 && g.ie6Compat)
							setTimeout(function () {
								u.element.getChild(0).$.style.cssText += '';
							}, 100);
					},
					hideChild : function () {
						var u = this._.activeChild;
						if (u) {
							delete u.onHide;
							delete u._.returnFocus;
							delete this._.activeChild;
							u.hide();
						}
					}
				}
			});
		f.on('instanceDestroyed', function () {
			var u = j.isEmpty(f.instances);
			for (var v in r) {
				var w = r[v];
				if (u)
					w.destroy();
				else
					w.element.hide();
			}
			u && (r = {});
		});
	})();
	o.add('menu', {
		beforeInit : function (r) {
			var s = r.config.menu_groups.split(','),
			t = r._.menuGroups = {},
			u = r._.menuItems = {};
			for (var v = 0; v < s.length; v++)
				t[s[v]] = v + 1;
			r.addMenuGroup = function (w, x) {
				t[w] = x || 100;
			};
			r.addMenuItem = function (w, x) {
				if (t[x.group])
					u[w] = new f.menuItem(this, w, x);
			};
			r.addMenuItems = function (w) {
				for (var x in w)
					this.addMenuItem(x, w[x]);
			};
			r.getMenuItem = function (w) {
				return u[w];
			};
			r.removeMenuItem = function (w) {
				delete u[w];
			};
		},
		requires : ['floatpanel']
	});
	(function () {
		f.menu = j.createClass({
				$ : function (s, t) {
					var w = this;
					t = w._.definition = t || {};
					w.id = j.getNextId();
					w.editor = s;
					w.items = [];
					w._.listeners = [];
					w._.level = t.level || 1;
					var u = j.extend({}, t.panel, {
							css : s.skin.editor.css,
							level : w._.level - 1,
							block : {}
							
						}),
					v = u.block.attributes = u.attributes || {};
					!v.role && (v.role = 'menu');
					w._.panelDefinition = u;
				},
				_ : {
					onShow : function () {
						var A = this;
						var s = A.editor.getSelection();
						if (h)
							s && s.lock();
						var t = s && s.getStartElement(),
						u = A._.listeners,
						v = [];
						A.removeAll();
						for (var w = 0; w < u.length; w++) {
							var x = u[w](t, s);
							if (x)
								for (var y in x) {
									var z = A.editor.getMenuItem(y);
									if (z && (!z.command || A.editor.getCommand(z.command).state)) {
										z.state = x[y];
										A.add(z);
									}
								}
						}
					},
					onClick : function (s) {
						this.hide(false);
						if (s.onClick)
							s.onClick();
						else if (s.command)
							this.editor.execCommand(s.command);
					},
					onEscape : function (s) {
						var t = this.parent;
						if (t) {
							t._.panel.hideChild();
							var u = t._.panel._.panel._.currentBlock,
							v = u._.focusIndex;
							u._.markItem(v);
						} else if (s == 27)
							this.hide();
						return false;
					},
					onHide : function () {
						this._.unlockSelection();
						this.onHide && this.onHide();
					},
					unlockSelection : function () {
						if (h && !this.parent) {
							var s = this.editor.getSelection();
							s && s.unlock(true);
						}
					},
					showSubMenu : function (s) {
						var A = this;
						var t = A._.subMenu,
						u = A.items[s],
						v = u.getItems && u.getItems();
						if (!v) {
							A._.panel.hideChild();
							return;
						}
						var w = A._.panel.getBlock(A.id);
						w._.focusIndex = s;
						if (t)
							t.removeAll();
						else {
							t = A._.subMenu = new f.menu(A.editor, j.extend({}, A._.definition, {
										level : A._.level + 1
									}, true));
							t.parent = A;
							t._.onClick = j.bind(A._.onClick, A);
						}
						for (var x in v) {
							var y = A.editor.getMenuItem(x);
							if (y) {
								y.state = v[x];
								t.add(y);
							}
						}
						var z = A._.panel.getBlock(A.id).element.getDocument().getById(A.id + String(s));
						t.show(z, 2);
					}
				},
				proto : {
					add : function (s) {
						if (!s.order)
							s.order = this.items.length;
						this.items.push(s);
					},
					removeAll : function () {
						this.items = [];
					},
					show : function (s, t, u, v) {
						if (!this.parent) {
							this._.onShow();
							if (!this.items.length) {
								this._.unlockSelection();
								return;
							}
						}
						t = t || (this.editor.lang.dir == 'rtl' ? 2 : 1);
						var w = this.items,
						x = this.editor,
						y = this._.panel,
						z = this._.element;
						if (!y) {
							y = this._.panel = new p.floatPanel(this.editor, f.document.getBody(), this._.panelDefinition, this._.level);
							y.onEscape = j.bind(function (K) {
									if (this._.onEscape(K) === false)
										return false;
								}, this);
							y.onHide = j.bind(function () {
									this._.onHide && this._.onHide();
								}, this);
							var A = y.addBlock(this.id, this._.panelDefinition.block);
							A.autoSize = true;
							var B = A.keys;
							B[40] = 'next';
							B[9] = 'next';
							B[38] = 'prev';
							B[2000 + 9] = 'prev';
							B[x.lang.dir == 'rtl' ? 37 : 39] = h ? 'mouseup' : 'click';
							B[32] = h ? 'mouseup' : 'click';
							h && (B[13] = 'mouseup');
							z = this._.element = A.element;
							z.addClass(x.skinClass);
							var C = z.getDocument();
							C.getBody().setStyle('overflow', 'hidden');
							C.getElementsByTag('html').getItem(0).setStyle('overflow', 'hidden');
							this._.itemOverFn = j.addFunction(function (K) {
									var L = this;
									clearTimeout(L._.showSubTimeout);
									L._.showSubTimeout = j.setTimeout(L._.showSubMenu, x.config.menu_subMenuDelay || 400, L, [K]);
								}, this);
							this._.itemOutFn = j.addFunction(function (K) {
									clearTimeout(this._.showSubTimeout);
								}, this);
							this._.itemClickFn = j.addFunction(function (K) {
									var M = this;
									var L = M.items[K];
									if (L.state == 0) {
										M.hide();
										return;
									}
									if (L.getItems)
										M._.showSubMenu(K);
									else
										M._.onClick(L);
								}, this);
						}
						r(w);
						var D = x.container.getChild(1),
						E = D.hasClass('cke_mixed_dir_content') ? ' cke_mixed_dir_content' : '',
						F = ['<div class="cke_menu' + E + '" role="presentation">'],
						G = w.length,
						H = G && w[0].group;
						for (var I = 0; I < G; I++) {
							var J = w[I];
							if (H != J.group) {
								F.push('<div class="cke_menuseparator" role="separator"></div>');
								H = J.group;
							}
							J.render(this, I, F);
						}
						F.push('</div>');
						z.setHtml(F.join(''));
						p.fire('ready', this);
						if (this.parent)
							this.parent._.panel.showAsChild(y, this.id, s, t, u, v);
						else
							y.showBlock(this.id, s, t, u, v);
						x.fire('menuShow', [y]);
					},
					addListener : function (s) {
						this._.listeners.push(s);
					},
					hide : function (s) {
						var t = this;
						t._.onHide && t._.onHide();
						t._.panel && t._.panel.hide(s);
					}
				}
			});
		function r(s) {
			s.sort(function (t, u) {
				if (t.group < u.group)
					return -1;
				else if (t.group > u.group)
					return 1;
				return t.order < u.order ? -1 : t.order > u.order ? 1 : 0;
			});
		};
		f.menuItem = j.createClass({
				$ : function (s, t, u) {
					var v = this;
					j.extend(v, u, {
						order : 0,
						className : 'cke_button_' + t
					});
					v.group = s._.menuGroups[v.group];
					v.editor = s;
					v.name = t;
				},
				proto : {
					render : function (s, t, u) {
						var B = this;
						var v = s.id + String(t),
						w = typeof B.state == 'undefined' ? 2 : B.state,
						x = ' cke_' + (w == 1 ? 'on' : w == 0 ? 'disabled' : 'off'),
						y = B.label;
						if (B.className)
							x += ' ' + B.className;
						var z = B.getItems;
						u.push('<span class="cke_menuitem' + (B.icon && B.icon.indexOf('.png') == -1 ? ' cke_noalphafix' : '') + '">' + '<a id="', v, '" class="', x, '" href="javascript:void(\'', (B.label || '').replace("'", ''), '\')" title="', B.label, '" tabindex="-1"_cke_focus=1 hidefocus="true" role="menuitem"' + (z ? 'aria-haspopup="true"' : '') + (w == 0 ? 'aria-disabled="true"' : '') + (w == 1 ? 'aria-pressed="true"' : ''));
						if (g.opera || g.gecko && g.mac)
							u.push(' onkeypress="return false;"');
						if (g.gecko)
							u.push(' onblur="this.style.cssText = this.style.cssText;"');
						var A = (B.iconOffset || 0) * -16;
						u.push(' onmouseover="CKEDITOR.tools.callFunction(', s._.itemOverFn, ',', t, ');" onmouseout="CKEDITOR.tools.callFunction(', s._.itemOutFn, ',', t, ');" ' + (h ? 'onclick="return false;" onmouseup' : 'onclick') + '="CKEDITOR.tools.callFunction(', s._.itemClickFn, ',', t, '); return false;"><span class="cke_icon_wrapper"><span class="cke_icon"' + (B.icon ? ' style="background-image:url(' + f.getUrl(B.icon) + ');background-position:0 ' + A + 'px;"' : '') + '></span></span>' + '<span class="cke_label">');
						if (z)
							u.push('<span class="cke_menuarrow">', '<span>&#', B.editor.lang.dir == 'rtl' ? '9668' : '9658', ';</span>', '</span>');
						u.push(y, '</span></a></span>');
					}
				}
			});
	})();
	n.menu_groups = 'clipboard,form,tablecell,tablecellproperties,tablerow,tablecolumn,table,anchor,link,image,flash,checkbox,radio,textfield,hiddenfield,imagebutton,button,select,textarea,div';
	(function () {
		var r;
		o.add('editingblock', {
			init : function (s) {
				if (!s.config.editingBlock)
					return;
				s.on('themeSpace', function (t) {
					if (t.data.space == 'contents')
						t.data.html += '<br>';
				});
				s.on('themeLoaded', function () {
					s.fireOnce('editingBlockReady');
				});
				s.on('uiReady', function () {
					s.setMode(s.config.startupMode);
				});
				s.on('afterSetData', function () {
					if (!r) {
						function t() {
							r = true;
							s.getMode().loadData(s.getData());
							r = false;
						};
						if (s.mode)
							t();
						else
							s.on('mode', function () {
								if (s.mode) {
									t();
									s.removeListener('mode', arguments.callee);
								}
							});
					}
				});
				s.on('beforeGetData', function () {
					if (!r && s.mode) {
						r = true;
						s.setData(s.getMode().getData(), null, 1);
						r = false;
					}
				});
				s.on('getSnapshot', function (t) {
					if (s.mode)
						t.data = s.getMode().getSnapshotData();
				});
				s.on('loadSnapshot', function (t) {
					if (s.mode)
						s.getMode().loadSnapshotData(t.data);
				});
				s.on('mode', function (t) {
					t.removeListener();
					g.webkit && s.container.on('focus', function () {
						s.focus();
					});
					if (s.config.startupFocus)
						s.focus();
					setTimeout(function () {
						s.fireOnce('instanceReady');
						f.fire('instanceReady', null, s);
					}, 0);
				});
				s.on('destroy', function () {
					var t = this;
					if (t.mode)
						t._.modes[t.mode].unload(t.getThemeSpace('contents'));
				});
			}
		});
		f.editor.prototype.mode = '';
		f.editor.prototype.addMode = function (s, t) {
			t.name = s;
			(this._.modes || (this._.modes = {}))[s] = t;
		};
		f.editor.prototype.setMode = function (s) {
			this.fire('beforeSetMode', {
				newMode : s
			});
			var t,
			u = this.getThemeSpace('contents'),
			v = this.checkDirty();
			if (this.mode) {
				if (s == this.mode)
					return;
				this._.previousMode = this.mode;
				this.fire('beforeModeUnload');
				var w = this.getMode();
				t = w.getData();
				w.unload(u);
				this.mode = '';
			}
			u.setHtml('');
			var x = this.getMode(s);
			if (!x)
				throw '[CKEDITOR.editor.setMode] Unknown mode "' + s + '".';
			if (!v)
				this.on('mode', function () {
					this.resetDirty();
					this.removeListener('mode', arguments.callee);
				});
			x.load(u, typeof t != 'string' ? this.getData() : t);
		};
		f.editor.prototype.getMode = function (s) {
			return this._.modes && this._.modes[s || this.mode];
		};
		f.editor.prototype.focus = function () {
			this.forceNextSelectionCheck();
			var s = this.getMode();
			if (s)
				s.focus();
		};
	})();
	n.startupMode = 'wysiwyg';
	n.editingBlock = true;
	(function () {
		function r() {
			var L = this;
			try {
				var I = L.getSelection();
				if (!I || !I.document.getWindow().$)
					return;
				var J = I.getStartElement(),
				K = new i.elementPath(J);
				if (!K.compare(L._.selectionPreviousPath)) {
					L._.selectionPreviousPath = K;
					L.fire('selectionChange', {
						selection : I,
						path : K,
						element : J
					});
				}
			} catch (M) {}
			
		};
		var s,
		t;
		function u() {
			t = true;
			if (s)
				return;
			v.call(this);
			s = j.setTimeout(v, 200, this);
		};
		function v() {
			s = null;
			if (t) {
				j.setTimeout(r, 0, this);
				t = false;
			}
		};
		function w(I) {
			function J(N, O) {
				if (!N || N.type == 3)
					return false;
				var P = I.clone();
				return P['moveToElementEdit' + (O ? 'End' : 'Start')](N);
			};
			var K = I.startContainer,
			L = I.getPreviousNode(F, null, K),
			M = I.getNextNode(F, null, K);
			if (J(L) || J(M, 1))
				return true;
			if (!(L || M) && !(K.type == 1 && K.isBlockBoundary() && K.getBogus()))
				return true;
			return false;
		};
		var x = {
			modes : {
				wysiwyg : 1,
				source : 1
			},
			readOnly : h || g.webkit,
			exec : function (I) {
				switch (I.mode) {
				case 'wysiwyg':
					I.document.$.execCommand('SelectAll', false, null);
					I.forceNextSelectionCheck();
					I.selectionChange();
					break;
				case 'source':
					var J = I.textarea.$;
					if (h)
						J.createTextRange().execCommand('SelectAll');
					else {
						J.selectionStart = 0;
						J.selectionEnd = J.value.length;
					}
					J.focus();
				}
			},
			canUndo : false
		};
		function y(I) {
			B(I);
			var J = I.createText('​');
			I.setCustomData('cke-fillingChar', J);
			return J;
		};
		function z(I) {
			return I && I.getCustomData('cke-fillingChar');
		};
		function A(I) {
			var J = I && z(I);
			if (J)
				if (J.getCustomData('ready'))
					B(I);
				else
					J.setCustomData('ready', 1);
		};
		function B(I) {
			var J = I && I.removeCustomData('cke-fillingChar');
			if (J) {
				var K,
				L = I.getSelection().getNative(),
				M = L && L.type != 'None' && L.getRangeAt(0);
				if (J.getLength() > 1 && M && M.intersectsNode(J.$)) {
					K = [L.anchorOffset, L.focusOffset];
					var N = L.anchorNode == J.$ && L.anchorOffset > 0,
					O = L.focusNode == J.$ && L.focusOffset > 0;
					N && K[0]--;
					O && K[1]--;
					C(L) && K.unshift(K.pop());
				}
				J.setText(J.getText().replace(/\u200B/g, ''));
				if (K) {
					var P = L.getRangeAt(0);
					P.setStart(P.startContainer, K[0]);
					P.setEnd(P.startContainer, K[1]);
					L.removeAllRanges();
					L.addRange(P);
				}
			}
		};
		function C(I) {
			if (!I.isCollapsed) {
				var J = I.getRangeAt(0);
				J.setStart(I.anchorNode, I.anchorOffset);
				J.setEnd(I.focusNode, I.focusOffset);
				return J.collapsed;
			}
		};
		o.add('selection', {
			init : function (I) {
				if (g.webkit) {
					I.on('selectionChange', function () {
						A(I.document);
					});
					I.on('beforeSetMode', function () {
						B(I.document);
					});
					var J,
					K;
					function L() {
						var N = I.document,
						O = z(N);
						if (O) {
							var P = N.$.defaultView.getSelection();
							if (P.type == 'Caret' && P.anchorNode == O.$)
								K = 1;
							J = O.getText();
							O.setText(J.replace(/\u200B/g, ''));
						}
					};
					function M() {
						var N = I.document,
						O = z(N);
						if (O) {
							O.setText(J);
							if (K) {
								N.$.defaultView.getSelection().setPosition(O.$, O.getLength());
								K = 0;
							}
						}
					};
					I.on('beforeUndoImage', L);
					I.on('afterUndoImage', M);
					I.on('beforeGetData', L, null, null, 0);
					I.on('getData', M);
				}
				I.on('contentDom', function () {
					var N = I.document,
					O = f.document,
					P = N.getBody(),
					Q = N.getDocumentElement();
					if (h) {
						var R,
						S,
						T = 1;
						P.on('focusin', function (aa) {
							if (aa.data.$.srcElement.nodeName != 'BODY')
								return;
							var ab = N.getCustomData('cke_locked_selection');
							if (ab) {
								ab.unlock(1);
								ab.lock();
							} else if (R && T) {
								try {
									R.select();
								} catch (ac) {}
								
								R = null;
							}
						});
						P.on('focus', function () {
							S = 1;
							Z();
						});
						P.on('beforedeactivate', function (aa) {
							if (aa.data.$.toElement)
								return;
							S = 0;
							T = 1;
						});
						h && I.on('blur', function () {
							try {
								N.$.selection.empty();
							} catch (aa) {}
							
						});
						Q.on('mousedown', function () {
							T = 0;
						});
						Q.on('mouseup', function () {
							T = 1;
						});
						var U;
						P.on('mousedown', function (aa) {
							if (aa.data.$.button == 2) {
								var ab = I.document.$.selection;
								if (ab.type == 'None')
									U = I.window.getScrollPosition();
							}
							Y();
						});
						P.on('mouseup', function (aa) {
							if (aa.data.$.button == 2 && U) {
								I.document.$.documentElement.scrollLeft = U.x;
								I.document.$.documentElement.scrollTop = U.y;
							}
							U = null;
							S = 1;
							setTimeout(function () {
								Z(true);
							}, 0);
						});
						P.on('keydown', Y);
						P.on('keyup', function () {
							S = 1;
							Z();
						});
						if (N.$.compatMode != 'BackCompat') {
							if (g.ie7Compat || g.ie6Compat) {
								function V(aa, ab, ac) {
									try {
										aa.moveToPoint(ab, ac);
									} catch (ad) {}
									
								};
								Q.on('mousedown', function (aa) {
									function ab(ag) {
										ag = ag.data.$;
										if (ae) {
											var ah = P.$.createTextRange();
											V(ah, ag.x, ag.y);
											ae.setEndPoint(af.compareEndPoints('StartToStart', ah) < 0 ? 'EndToEnd' : 'StartToStart', ah);
											ae.select();
										}
									};
									function ac() {
										O.removeListener('mouseup', ad);
										Q.removeListener('mouseup', ad);
									};
									function ad() {
										Q.removeListener('mousemove', ab);
										ac();
										ae.select();
									};
									aa = aa.data;
									if (aa.getTarget().is('html') && aa.$.x < Q.$.clientWidth && aa.$.y < Q.$.clientHeight) {
										var ae = P.$.createTextRange();
										V(ae, aa.$.x, aa.$.y);
										var af = ae.duplicate();
										Q.on('mousemove', ab);
										O.on('mouseup', ad);
										Q.on('mouseup', ad);
									}
								});
							}
							if (g.ie8) {
								Q.on('mousedown', function (aa) {
									if (aa.data.getTarget().is('html')) {
										O.on('mouseup', X);
										Q.on('mouseup', X);
									}
								});
								function W() {
									O.removeListener('mouseup', X);
									Q.removeListener('mouseup', X);
								};
								function X() {
									W();
									var aa = f.document.$.selection,
									ab = aa.createRange();
									if (aa.type != 'None' && ab.parentElement().ownerDocument == N.$)
										ab.select();
								};
							}
						}
						N.on('selectionchange', Z);
						function Y() {
							S = 0;
						};
						function Z(aa) {
							if (S) {
								var ab = I.document,
								ac = I.getSelection(),
								ad = ac && ac.getNative();
								if (aa && ad && ad.type == 'None')
									if (!ab.$.queryCommandEnabled('InsertImage')) {
										j.setTimeout(Z, 50, this, true);
										return;
									}
								var ae;
								if (ad && ad.type && ad.type != 'Control' && (ae = ad.createRange()) && (ae = ae.parentElement()) && (ae = ae.nodeName) && ae.toLowerCase()in {
									input : 1,
									textarea : 1
								})
									return;
								try {
									R = ad && ac.getRanges()[0];
								} catch (af) {}
								
								u.call(I);
							}
						};
					} else {
						N.on('mouseup', u, I);
						N.on('keyup', u, I);
						N.on('selectionchange', u, I);
					}
					if (g.webkit)
						N.on('keydown', function (aa) {
							var ab = aa.data.getKey();
							switch (ab) {
							case 13:
							case 33:
							case 34:
							case 35:
							case 36:
							case 37:
							case 39:
							case 8:
							case 45:
							case 46:
								B(I.document);
							}
						}, null, null, -1);
				});
				I.on('contentDomUnload', I.forceNextSelectionCheck, I);
				I.addCommand('selectAll', x);
				I.ui.addButton('SelectAll', {
					label : I.lang.selectAll,
					command : 'selectAll'
				});
				I.selectionChange = function (N) {
					(N ? r : u).call(this);
				};
				g.ie9Compat && I.on('destroy', function () {
					var N = I.getSelection();
					N && N.getNative().clear();
				}, null, null, 9);
			}
		});
		f.editor.prototype.getSelection = function () {
			return this.document && this.document.getSelection();
		};
		f.editor.prototype.forceNextSelectionCheck = function () {
			delete this._.selectionPreviousPath;
		};
		l.prototype.getSelection = function () {
			var I = new i.selection(this);
			return !I || I.isInvalid ? null : I;
		};
		f.SELECTION_NONE = 1;
		f.SELECTION_TEXT = 2;
		f.SELECTION_ELEMENT = 3;
		i.selection = function (I) {
			var L = this;
			var J = I.getCustomData('cke_locked_selection');
			if (J)
				return J;
			L.document = I;
			L.isLocked = 0;
			L._ = {
				cache : {}
				
			};
			if (h)
				try {
					var K = L.getNative().createRange();
					if (!K || K.item && K.item(0).ownerDocument != L.document.$ || K.parentElement && K.parentElement().ownerDocument != L.document.$)
						throw 0;
				} catch (M) {
					L.isInvalid = true;
				}
			return L;
		};
		var D = {
			img : 1,
			hr : 1,
			li : 1,
			table : 1,
			tr : 1,
			td : 1,
			th : 1,
			embed : 1,
			object : 1,
			ol : 1,
			ul : 1,
			a : 1,
			input : 1,
			form : 1,
			select : 1,
			textarea : 1,
			button : 1,
			fieldset : 1,
			thead : 1,
			tfoot : 1
		};
		i.selection.prototype = {
			getNative : h ? function () {
				return this._.cache.nativeSel || (this._.cache.nativeSel = this.document.$.selection);
			}
			 : function () {
				return this._.cache.nativeSel || (this._.cache.nativeSel = this.document.getWindow().$.getSelection());
			},
			getType : h ? function () {
				var I = this._.cache;
				if (I.type)
					return I.type;
				var J = 1;
				try {
					var K = this.getNative(),
					L = K.type;
					if (L == 'Text')
						J = 2;
					if (L == 'Control')
						J = 3;
					if (K.createRange().parentElement)
						J = 2;
				} catch (M) {}
				
				return I.type = J;
			}
			 : function () {
				var I = this._.cache;
				if (I.type)
					return I.type;
				var J = 2,
				K = this.getNative();
				if (!K)
					J = 1;
				else if (K.rangeCount == 1) {
					var L = K.getRangeAt(0),
					M = L.startContainer;
					if (M == L.endContainer && M.nodeType == 1 && L.endOffset - L.startOffset == 1 && D[M.childNodes[L.startOffset].nodeName.toLowerCase()])
						J = 3;
				}
				return I.type = J;
			},
			getRanges : (function () {
				var I = h ? (function () {
						function J(L) {
							return new i.node(L).getIndex();
						};
						var K = function (L, M) {
							L = L.duplicate();
							L.collapse(M);
							var N = L.parentElement(),
							O = N.ownerDocument;
							if (!N.hasChildNodes())
								return {
									container : N,
									offset : 0
								};
							var P = N.children,
							Q,
							R,
							S = L.duplicate(),
							T = 0,
							U = P.length - 1,
							V = -1,
							W,
							X,
							Y;
							while (T <= U) {
								V = Math.floor((T + U) / 2);
								Q = P[V];
								S.moveToElementText(Q);
								W = S.compareEndPoints('StartToStart', L);
								if (W > 0)
									U = V - 1;
								else if (W < 0)
									T = V + 1;
								else if (g.ie9Compat && Q.tagName == 'BR') {
									var Z = O.defaultView.getSelection();
									return {
										container : Z[M ? 'anchorNode' : 'focusNode'],
										offset : Z[M ? 'anchorOffset' : 'focusOffset']
									};
								} else
									return {
										container : N,
										offset : J(Q)
									};
							}
							if (V == -1 || V == P.length - 1 && W < 0) {
								S.moveToElementText(N);
								S.setEndPoint('StartToStart', L);
								X = S.text.replace(/(\r\n|\r)/g, '\n').length;
								P = N.childNodes;
								if (!X) {
									Q = P[P.length - 1];
									if (Q.nodeType != 3)
										return {
											container : N,
											offset : P.length
										};
									else
										return {
											container : Q,
											offset : Q.nodeValue.length
										};
								}
								var aa = P.length;
								while (X > 0 && aa > 0) {
									R = P[--aa];
									if (R.nodeType == 3) {
										Y = R;
										X -= R.nodeValue.length;
									}
								}
								return {
									container : Y,
									offset : -X
								};
							} else {
								S.collapse(W > 0 ? true : false);
								S.setEndPoint(W > 0 ? 'StartToStart' : 'EndToStart', L);
								X = S.text.replace(/(\r\n|\r)/g, '\n').length;
								if (!X)
									return {
										container : N,
										offset : J(Q) + (W > 0 ? 0 : 1)
									};
								while (X > 0)
									try {
										R = Q[W > 0 ? 'previousSibling' : 'nextSibling'];
										if (R.nodeType == 3) {
											X -= R.nodeValue.length;
											Y = R;
										}
										Q = R;
									} catch (ab) {
										return {
											container : N,
											offset : J(Q)
										};
									}
								return {
									container : Y,
									offset : W > 0 ? -X : Y.nodeValue.length + X
								};
							}
						};
						return function () {
							var V = this;
							var L = V.getNative(),
							M = L && L.createRange(),
							N = V.getType(),
							O;
							if (!L)
								return [];
							if (N == 2) {
								O = new i.range(V.document);
								var P = K(M, true);
								O.setStart(new i.node(P.container), P.offset);
								P = K(M);
								O.setEnd(new i.node(P.container), P.offset);
								if (O.endContainer.getPosition(O.startContainer) & 4 && O.endOffset <= O.startContainer.getIndex())
									O.collapse();
								return [O];
							} else if (N == 3) {
								var Q = [];
								for (var R = 0; R < M.length; R++) {
									var S = M.item(R),
									T = S.parentNode,
									U = 0;
									O = new i.range(V.document);
									for (; U < T.childNodes.length && T.childNodes[U] != S; U++) {}
									
									O.setStart(new i.node(T), U);
									O.setEnd(new i.node(T), U + 1);
									Q.push(O);
								}
								return Q;
							}
							return [];
						};
					})() : function () {
					var J = [],
					K,
					L = this.document,
					M = this.getNative();
					if (!M)
						return J;
					if (!M.rangeCount) {
						K = new i.range(L);
						K.moveToElementEditStart(L.getBody());
						J.push(K);
					}
					for (var N = 0; N < M.rangeCount; N++) {
						var O = M.getRangeAt(N);
						K = new i.range(L);
						K.setStart(new i.node(O.startContainer), O.startOffset);
						K.setEnd(new i.node(O.endContainer), O.endOffset);
						J.push(K);
					}
					return J;
				};
				return function (J) {
					var K = this._.cache;
					if (K.ranges && !J)
						return K.ranges;
					else if (!K.ranges)
						K.ranges = new i.rangeList(I.call(this));
					if (J) {
						var L = K.ranges;
						for (var M = 0; M < L.length; M++) {
							var N = L[M],
							O = N.getCommonAncestor();
							if (O.isReadOnly())
								L.splice(M, 1);
							if (N.collapsed)
								continue;
							if (N.startContainer.isReadOnly()) {
								var P = N.startContainer;
								while (P) {
									if (P.is('body') || !P.isReadOnly())
										break;
									if (P.type == 1 && P.getAttribute('contentEditable') == 'false')
										N.setStartAfter(P);
									P = P.getParent();
								}
							}
							var Q = N.startContainer,
							R = N.endContainer,
							S = N.startOffset,
							T = N.endOffset,
							U = N.clone();
							if (Q && Q.type == 3)
								if (S >= Q.getLength())
									U.setStartAfter(Q);
								else
									U.setStartBefore(Q);
							if (R && R.type == 3)
								if (!T)
									U.setEndBefore(R);
								else
									U.setEndAfter(R);
							var V = new i.walker(U);
							V.evaluator = function (W) {
								if (W.type == 1 && W.isReadOnly()) {
									var X = N.clone();
									N.setEndBefore(W);
									if (N.collapsed)
										L.splice(M--, 1);
									if (!(W.getPosition(U.endContainer) & 16)) {
										X.setStartAfter(W);
										if (!X.collapsed)
											L.splice(M + 1, 0, X);
									}
									return true;
								}
								return false;
							};
							V.next();
						}
					}
					return K.ranges;
				};
			})(),
			getStartElement : function () {
				var P = this;
				var I = P._.cache;
				if (I.startElement !== undefined)
					return I.startElement;
				var J,
				K = P.getNative();
				switch (P.getType()) {
				case 3:
					return P.getSelectedElement();
				case 2:
					var L = P.getRanges()[0];
					if (L) {
						if (!L.collapsed) {
							L.optimize();
							while (1) {
								var M = L.startContainer,
								N = L.startOffset;
								if (N == (M.getChildCount ? M.getChildCount() : M.getLength()) && !M.isBlockBoundary())
									L.setStartAfter(M);
								else
									break;
							}
							J = L.startContainer;
							if (J.type != 1)
								return J.getParent();
							J = J.getChild(L.startOffset);
							if (!J || J.type != 1)
								J = L.startContainer;
							else {
								var O = J.getFirst();
								while (O && O.type == 1) {
									J = O;
									O = O.getFirst();
								}
							}
						} else {
							J = L.startContainer;
							if (J.type != 1)
								J = J.getParent();
						}
						J = J.$;
					}
				}
				return I.startElement = J ? new m(J) : null;
			},
			getSelectedElement : function () {
				var I = this._.cache;
				if (I.selectedElement !== undefined)
					return I.selectedElement;
				var J = this,
				K = j.tryThese(function () {
						return J.getNative().createRange().item(0);
					}, function () {
						var L,
						M,
						N = J.getRanges()[0],
						O = N.getCommonAncestor(1, 1),
						P = {
							table : 1,
							ul : 1,
							ol : 1,
							dl : 1
						};
						for (var Q in P) {
							if (L = O.getAscendant(Q, 1))
								break;
						}
						if (L) {
							var R = new i.range(this.document);
							R.setStartAt(L, 1);
							R.setEnd(N.startContainer, N.startOffset);
							var S = j.extend(P, k.$listItem, k.$tableContent),
							T = new i.walker(R),
							U = function (V, W) {
								return function (X, Y) {
									if (X.type == 3 && (!j.trim(X.getText()) || X.getParent().data('cke-bookmark')))
										return true;
									var Z;
									if (X.type == 1) {
										Z = X.getName();
										if (Z == 'br' && W && X.equals(X.getParent().getBogus()))
											return true;
										if (Y && Z in S || Z in k.$removeEmpty)
											return true;
									}
									V.halted = 1;
									return false;
								};
							};
							T.guard = U(T);
							if (T.checkBackward() && !T.halted) {
								T = new i.walker(R);
								R.setStart(N.endContainer, N.endOffset);
								R.setEndAt(L, 2);
								T.guard = U(T, 1);
								if (T.checkForward() && !T.halted)
									M = L.$;
							}
						}
						if (!M)
							throw 0;
						return M;
					}, function () {
						var L = J.getRanges()[0],
						M,
						N;
						for (var O = 2; O && !((M = L.getEnclosedNode()) && M.type == 1 && D[M.getName()] && (N = M));
							O--)
							L.shrink(1);
						return N.$;
					});
				return I.selectedElement = K ? new m(K) : null;
			},
			getSelectedText : function () {
				var I = this._.cache;
				if (I.selectedText !== undefined)
					return I.selectedText;
				var J = '',
				K = this.getNative();
				if (this.getType() == 2)
					J = h ? K.createRange().text : K.toString();
				return I.selectedText = J;
			},
			lock : function () {
				var I = this;
				I.getRanges();
				I.getStartElement();
				I.getSelectedElement();
				I.getSelectedText();
				I._.cache.nativeSel = {};
				I.isLocked = 1;
				I.document.setCustomData('cke_locked_selection', I);
			},
			unlock : function (I) {
				var N = this;
				var J = N.document,
				K = J.getCustomData('cke_locked_selection');
				if (K) {
					J.setCustomData('cke_locked_selection', null);
					if (I) {
						var L = K.getSelectedElement(),
						M = !L && K.getRanges();
						N.isLocked = 0;
						N.reset();
						if (L)
							N.selectElement(L);
						else
							N.selectRanges(M);
					}
				}
				if (!K || !I) {
					N.isLocked = 0;
					N.reset();
				}
			},
			reset : function () {
				this._.cache = {};
			},
			selectElement : function (I) {
				var K = this;
				if (K.isLocked) {
					var J = new i.range(K.document);
					J.setStartBefore(I);
					J.setEndAfter(I);
					K._.cache.selectedElement = I;
					K._.cache.startElement = I;
					K._.cache.ranges = new i.rangeList(J);
					K._.cache.type = 3;
					return;
				}
				J = new i.range(I.getDocument());
				J.setStartBefore(I);
				J.setEndAfter(I);
				J.select();
				K.document.fire('selectionchange');
				K.reset();
			},
			selectRanges : function (I) {
				var W = this;
				if (W.isLocked) {
					W._.cache.selectedElement = null;
					W._.cache.startElement = I[0] && I[0].getTouchedStartNode();
					W._.cache.ranges = new i.rangeList(I);
					W._.cache.type = 2;
					return;
				}
				if (h) {
					if (I.length > 1) {
						var J = I[I.length - 1];
						I[0].setEnd(J.endContainer, J.endOffset);
						I.length = 1;
					}
					if (I[0])
						I[0].select();
					W.reset();
				} else {
					var K = W.getNative();
					if (!K)
						return;
					if (I.length) {
						K.removeAllRanges();
						g.webkit && B(W.document);
					}
					for (var L = 0; L < I.length; L++) {
						if (L < I.length - 1) {
							var M = I[L],
							N = I[L + 1],
							O = M.clone();
							O.setStart(M.endContainer, M.endOffset);
							O.setEnd(N.startContainer, N.startOffset);
							if (!O.collapsed) {
								O.shrink(1, true);
								var P = O.getCommonAncestor(),
								Q = O.getEnclosedNode();
								if (P.isReadOnly() || Q && Q.isReadOnly()) {
									N.setStart(M.startContainer, M.startOffset);
									I.splice(L--, 1);
									continue;
								}
							}
						}
						var R = I[L],
						S = W.document.$.createRange(),
						T = R.startContainer;
						if (R.collapsed && (g.opera || g.gecko && g.version < 10900) && T.type == 1 && !T.getChildCount())
							T.appendText('');
						if (R.collapsed && g.webkit && w(R)) {
							var U = y(W.document);
							R.insertNode(U);
							var V = U.getNext();
							if (V && !U.getPrevious() && V.type == 1 && V.getName() == 'br') {
								B(W.document);
								R.moveToPosition(V, 3);
							} else
								R.moveToPosition(U, 4);
						}
						S.setStart(R.startContainer.$, R.startOffset);
						try {
							S.setEnd(R.endContainer.$, R.endOffset);
						} catch (X) {
							if (X.toString().indexOf('NS_ERROR_ILLEGAL_VALUE') >= 0) {
								R.collapse(1);
								S.setEnd(R.endContainer.$, R.endOffset);
							} else
								throw X;
						}
						K.addRange(S);
					}
					W.document.fire('selectionchange');
					W.reset();
				}
			},
			createBookmarks : function (I) {
				return this.getRanges().createBookmarks(I);
			},
			createBookmarks2 : function (I) {
				return this.getRanges().createBookmarks2(I);
			},
			selectBookmarks : function (I) {
				var J = [];
				for (var K = 0; K < I.length; K++) {
					var L = new i.range(this.document);
					L.moveToBookmark(I[K]);
					J.push(L);
				}
				this.selectRanges(J);
				return this;
			},
			getCommonAncestor : function () {
				var I = this.getRanges(),
				J = I[0].startContainer,
				K = I[I.length - 1].endContainer;
				return J.getCommonAncestor(K);
			},
			scrollIntoView : function () {
				var I = this.getStartElement();
				I.scrollIntoView();
			}
		};
		var E = i.walker.whitespaces(true),
		F = i.walker.invisible(1),
		G = /\ufeff|\u00a0/,
		H = {
			table : 1,
			tbody : 1,
			tr : 1
		};
		i.range.prototype.select = h ? function (I) {
			var T = this;
			var J = T.collapsed,
			K,
			L,
			M,
			N = T.getEnclosedNode();
			if (N)
				try {
					M = T.document.$.body.createControlRange();
					M.addElement(N.$);
					M.select();
					return;
				} catch (U) {}
				
			if (T.startContainer.type == 1 && T.startContainer.getName()in H || T.endContainer.type == 1 && T.endContainer.getName()in H)
				T.shrink(1, true);
			var O = T.createBookmark(),
			P = O.startNode,
			Q;
			if (!J)
				Q = O.endNode;
			M = T.document.$.body.createTextRange();
			M.moveToElementText(P.$);
			M.moveStart('character', 1);
			if (Q) {
				var R = T.document.$.body.createTextRange();
				R.moveToElementText(Q.$);
				M.setEndPoint('EndToEnd', R);
				M.moveEnd('character', -1);
			} else {
				var S = P.getNext(E);
				K = !(S && S.getText && S.getText().match(G)) && (I || !P.hasPrevious() || P.getPrevious().is && P.getPrevious().is('br'));
				L = T.document.createElement('span');
				L.setHtml('&#65279;');
				L.insertBefore(P);
				if (K)
					T.document.createText('\ufeff').insertBefore(P);
			}
			T.setStartBefore(P);
			P.remove();
			if (J) {
				if (K) {
					M.moveStart('character', -1);
					M.select();
					T.document.$.selection.clear();
				} else
					M.select();
				T.moveToPosition(L, 3);
				L.remove();
			} else {
				T.setEndBefore(Q);
				Q.remove();
				M.select();
			}
			T.document.fire('selectionchange');
		}
		 : function () {
			this.document.getSelection().selectRanges([this]);
		};
	})();
	(function () {
		var r = f.htmlParser.cssStyle,
		s = j.cssLength,
		t = /^((?:\d*(?:\.\d+))|(?:\d+))(.*)?$/i;
		function u(w, x) {
			var y = t.exec(w),
			z = t.exec(x);
			if (y) {
				if (!y[2] && z[2] == 'px')
					return z[1];
				if (y[2] == 'px' && !z[2])
					return z[1] + 'px';
			}
			return x;
		};
		var v = {
			elements : {
				$ : function (w) {
					var x = w.attributes,
					y = x && x['data-cke-realelement'],
					z = y && new f.htmlParser.fragment.fromHtml(decodeURIComponent(y)),
					A = z && z.children[0];
					if (A && w.attributes['data-cke-resizable']) {
						var B = new r(w).rules,
						C = A.attributes,
						D = B.width,
						E = B.height;
						D && (C.width = u(C.width, D));
						E && (C.height = u(C.height, E));
					}
					return A;
				}
			}
		};
		o.add('fakeobjects', {
			requires : ['htmlwriter'],
			afterInit : function (w) {
				var x = w.dataProcessor,
				y = x && x.htmlFilter;
				if (y)
					y.addRules(v);
			}
		});
		f.editor.prototype.createFakeElement = function (w, x, y, z) {
			var A = this.lang.fakeobjects,
			B = A[y] || A.unknown,
			C = {
				'class' : x,
				'data-cke-realelement' : encodeURIComponent(w.getOuterHtml()),
				'data-cke-real-node-type' : w.type,
				alt : B,
				title : B,
				align : w.getAttribute('align') || ''
			};
			if (!g.hc)
				C.src = f.getUrl('images/spacer.gif');
			if (y)
				C['data-cke-real-element-type'] = y;
			if (z) {
				C['data-cke-resizable'] = z;
				var D = new r(),
				E = w.getAttribute('width'),
				F = w.getAttribute('height');
				E && (D.rules.width = s(E));
				F && (D.rules.height = s(F));
				D.populate(C);
			}
			return this.document.createElement('img', {
				attributes : C
			});
		};
		f.editor.prototype.createFakeParserElement = function (w, x, y, z) {
			var A = this.lang.fakeobjects,
			B = A[y] || A.unknown,
			C,
			D = new f.htmlParser.basicWriter();
			w.writeHtml(D);
			C = D.getHtml();
			var E = {
				'class' : x,
				'data-cke-realelement' : encodeURIComponent(C),
				'data-cke-real-node-type' : w.type,
				alt : B,
				title : B,
				align : w.attributes.align || ''
			};
			if (!g.hc)
				E.src = f.getUrl('images/spacer.gif');
			if (y)
				E['data-cke-real-element-type'] = y;
			if (z) {
				E['data-cke-resizable'] = z;
				var F = w.attributes,
				G = new r(),
				H = F.width,
				I = F.height;
				H != undefined && (G.rules.width = s(H));
				I != undefined && (G.rules.height = s(I));
				G.populate(E);
			}
			return new f.htmlParser.element('img', E);
		};
		f.editor.prototype.restoreRealElement = function (w) {
			if (w.data('cke-real-node-type') != 1)
				return null;
			var x = m.createFromHtml(decodeURIComponent(w.data('cke-realelement')), this.document);
			if (w.data('cke-resizable')) {
				var y = w.getStyle('width'),
				z = w.getStyle('height');
				y && x.setAttribute('width', u(x.getAttribute('width'), y));
				z && x.setAttribute('height', u(x.getAttribute('height'), z));
			}
			return x;
		};
	})();
	o.add('richcombo', {
		requires : ['floatpanel', 'listblock', 'button'],
		beforeInit : function (r) {
			r.ui.addHandler(3, p.richCombo.handler);
		}
	});
	f.UI_RICHCOMBO = 'richcombo';
	p.richCombo = j.createClass({
			$ : function (r) {
				var t = this;
				j.extend(t, r, {
					title : r.label,
					modes : {
						wysiwyg : 1
					}
				});
				var s = t.panel || {};
				delete t.panel;
				t.id = j.getNextNumber();
				t.document = s && s.parent && s.parent.getDocument() || f.document;
				s.className = (s.className || '') + ' cke_rcombopanel';
				s.block = {
					multiSelect : s.multiSelect,
					attributes : s.attributes
				};
				t._ = {
					panelDefinition : s,
					items : {},
					state : 2
				};
			},
			statics : {
				handler : {
					create : function (r) {
						return new p.richCombo(r);
					}
				}
			},
			proto : {
				renderHtml : function (r) {
					var s = [];
					this.render(r, s);
					return s.join('');
				},
				render : function (r, s) {
					var t = g,
					u = 'cke_' + this.id,
					v = j.addFunction(function (A) {
							var D = this;
							var B = D._;
							if (B.state == 0)
								return;
							D.createPanel(r);
							if (B.on) {
								B.panel.hide();
								return;
							}
							D.commit();
							var C = D.getValue();
							if (C)
								B.list.mark(C);
							else
								B.list.unmarkAll();
							B.panel.showBlock(D.id, new m(A), 4);
						}, this),
					w = {
						id : u,
						combo : this,
						focus : function () {
							var A = f.document.getById(u).getChild(1);
							A.focus();
						},
						clickFn : v
					};
					function x() {
						var B = this;
						var A = B.modes[r.mode] ? 2 : 0;
						B.setState(r.readOnly && !B.readOnly ? 0 : A);
						B.setValue('');
					};
					r.on('mode', x, this);
					!this.readOnly && r.on('readOnly', x, this);
					var y = j.addFunction(function (A, B) {
							A = new i.event(A);
							var C = A.getKeystroke();
							switch (C) {
							case 13:
							case 32:
							case 40:
								j.callFunction(v, B);
								break;
							default:
								w.onkey(w, C);
							}
							A.preventDefault();
						}),
					z = j.addFunction(function () {
							w.onfocus && w.onfocus();
						});
					w.keyDownFn = y;
					s.push('<span class="cke_rcombo" role="presentation">', '<span id=', u);
					if (this.className)
						s.push(' class="', this.className, ' cke_off"');
					s.push(' role="presentation">', '<span id="' + u + '_label" class=cke_label>', this.label, '</span>', '<a hidefocus=true title="', this.title, '" tabindex="-1"', t.gecko && t.version >= 10900 && !t.hc ? '' : " href=\"javascript:void('" + this.label + "')\"", ' role="button" aria-labelledby="', u, '_label" aria-describedby="', u, '_text" aria-haspopup="true"');
					if (g.opera || g.gecko && g.mac)
						s.push(' onkeypress="return false;"');
					if (g.gecko)
						s.push(' onblur="this.style.cssText = this.style.cssText;"');
					s.push(' onkeydown="CKEDITOR.tools.callFunction( ', y, ', event, this );" onfocus="return CKEDITOR.tools.callFunction(', z, ', event);" ' + (h ? 'onclick="return false;" onmouseup' : 'onclick') + '="CKEDITOR.tools.callFunction(', v, ', this); return false;"><span><span id="' + u + '_text" class="cke_text cke_inline_label">' + this.label + '</span>' + '</span>' + '<span class=cke_openbutton><span class=cke_icon>' + (g.hc ? '&#9660;' : g.air ? '&nbsp;' : '') + '</span></span>' + '</a>' + '</span>' + '</span>');
					if (this.onRender)
						this.onRender();
					return w;
				},
				createPanel : function (r) {
					if (this._.panel)
						return;
					var s = this._.panelDefinition,
					t = this._.panelDefinition.block,
					u = s.parent || f.document.getBody(),
					v = new p.floatPanel(r, u, s),
					w = v.addListBlock(this.id, t),
					x = this;
					v.onShow = function () {
						if (x.className)
							this.element.getFirst().addClass(x.className + '_panel');
						x.setState(1);
						w.focus(!x.multiSelect && x.getValue());
						x._.on = 1;
						if (x.onOpen)
							x.onOpen();
					};
					v.onHide = function (y) {
						if (x.className)
							this.element.getFirst().removeClass(x.className + '_panel');
						x.setState(x.modes && x.modes[r.mode] ? 2 : 0);
						x._.on = 0;
						if (!y && x.onClose)
							x.onClose();
					};
					v.onEscape = function () {
						v.hide();
					};
					w.onClick = function (y, z) {
						x.document.getWindow().focus();
						if (x.onClick)
							x.onClick.call(x, y, z);
						if (z)
							x.setValue(y, x._.items[y]);
						else
							x.setValue('');
						v.hide(false);
					};
					this._.panel = v;
					this._.list = w;
					v.getBlock(this.id).onHide = function () {
						x._.on = 0;
						x.setState(2);
					};
					if (this.init)
						this.init();
				},
				setValue : function (r, s) {
					var u = this;
					u._.value = r;
					var t = u.document.getById('cke_' + u.id + '_text');
					if (t) {
						if (!(r || s)) {
							s = u.label;
							t.addClass('cke_inline_label');
						} else
							t.removeClass('cke_inline_label');
						t.setHtml(typeof s != 'undefined' ? s : r);
					}
				},
				getValue : function () {
					return this._.value || '';
				},
				unmarkAll : function () {
					this._.list.unmarkAll();
				},
				mark : function (r) {
					this._.list.mark(r);
				},
				hideItem : function (r) {
					this._.list.hideItem(r);
				},
				hideGroup : function (r) {
					this._.list.hideGroup(r);
				},
				showAll : function () {
					this._.list.showAll();
				},
				add : function (r, s, t) {
					this._.items[r] = t || r;
					this._.list.add(r, s, t);
				},
				startGroup : function (r) {
					this._.list.startGroup(r);
				},
				commit : function () {
					var r = this;
					if (!r._.committed) {
						r._.list.commit();
						r._.committed = 1;
						p.fire('ready', r);
					}
					r._.committed = 1;
				},
				setState : function (r) {
					var s = this;
					if (s._.state == r)
						return;
					s.document.getById('cke_' + s.id).setState(r);
					s._.state = r;
				}
			}
		});
	p.prototype.addRichCombo = function (r, s) {
		this.add(r, 3, s);
	};
	o.add('htmlwriter');
	f.htmlWriter = j.createClass({
			base : f.htmlParser.basicWriter,
			$ : function () {
				var t = this;
				t.base();
				t.indentationChars = '\t';
				t.selfClosingEnd = ' />';
				t.lineBreakChars = '\n';
				t.forceSimpleAmpersand = 0;
				t.sortAttributes = 1;
				t._.indent = 0;
				t._.indentation = '';
				t._.inPre = 0;
				t._.rules = {};
				var r = k;
				for (var s in j.extend({}, r.$nonBodyContent, r.$block, r.$listItem, r.$tableContent))
					t.setRules(s, {
						indent : 1,
						breakBeforeOpen : 1,
						breakAfterOpen : 1,
						breakBeforeClose : !r[s]['#'],
						breakAfterClose : 1
					});
				t.setRules('br', {
					breakAfterOpen : 1
				});
				t.setRules('title', {
					indent : 0,
					breakAfterOpen : 0
				});
				t.setRules('style', {
					indent : 0,
					breakBeforeClose : 1
				});
				t.setRules('pre', {
					indent : 0
				});
			},
			proto : {
				openTag : function (r, s) {
					var u = this;
					var t = u._.rules[r];
					if (u._.indent)
						u.indentation();
					else if (t && t.breakBeforeOpen) {
						u.lineBreak();
						u.indentation();
					}
					u._.output.push('<', r);
				},
				openTagClose : function (r, s) {
					var u = this;
					var t = u._.rules[r];
					if (s)
						u._.output.push(u.selfClosingEnd);
					else {
						u._.output.push('>');
						if (t && t.indent)
							u._.indentation += u.indentationChars;
					}
					if (t && t.breakAfterOpen)
						u.lineBreak();
					r == 'pre' && (u._.inPre = 1);
				},
				attribute : function (r, s) {
					if (typeof s == 'string') {
						this.forceSimpleAmpersand && (s = s.replace(/&amp;/g, '&'));
						s = j.htmlEncodeAttr(s);
					}
					this._.output.push(' ', r, '="', s, '"');
				},
				closeTag : function (r) {
					var t = this;
					var s = t._.rules[r];
					if (s && s.indent)
						t._.indentation = t._.indentation.substr(t.indentationChars.length);
					if (t._.indent)
						t.indentation();
					else if (s && s.breakBeforeClose) {
						t.lineBreak();
						t.indentation();
					}
					t._.output.push('</', r, '>');
					r == 'pre' && (t._.inPre = 0);
					if (s && s.breakAfterClose)
						t.lineBreak();
				},
				text : function (r) {
					var s = this;
					if (s._.indent) {
						s.indentation();
						!s._.inPre && (r = j.ltrim(r));
					}
					s._.output.push(r);
				},
				comment : function (r) {
					if (this._.indent)
						this.indentation();
					this._.output.push('<!--', r, '-->');
				},
				lineBreak : function () {
					var r = this;
					if (!r._.inPre && r._.output.length > 0)
						r._.output.push(r.lineBreakChars);
					r._.indent = 1;
				},
				indentation : function () {
					var r = this;
					if (!r._.inPre)
						r._.output.push(r._.indentation);
					r._.indent = 0;
				},
				setRules : function (r, s) {
					var t = this._.rules[r];
					if (t)
						j.extend(t, s, true);
					else
						this._.rules[r] = s;
				}
			}
		});
	o.add('menubutton', {
		requires : ['button', 'menu'],
		beforeInit : function (r) {
			r.ui.addHandler(5, p.menuButton.handler);
		}
	});
	f.UI_MENUBUTTON = 'menubutton';
	(function () {
		var r = function (s) {
			var t = this._;
			if (t.state === 0)
				return;
			t.previousState = t.state;
			var u = t.menu;
			if (!u) {
				u = t.menu = new f.menu(s, {
						panel : {
							className : s.skinClass + ' cke_contextmenu',
							attributes : {
								'aria-label' : s.lang.common.options
							}
						}
					});
				u.onHide = j.bind(function () {
						this.setState(this.modes && this.modes[s.mode] ? t.previousState : 0);
					}, this);
				if (this.onMenu)
					u.addListener(this.onMenu);
			}
			if (t.on) {
				u.hide();
				return;
			}
			this.setState(1);
			u.show(f.document.getById(this._.id), 4);
		};
		p.menuButton = j.createClass({
				base : p.button,
				$ : function (s) {
					var t = s.panel;
					delete s.panel;
					this.base(s);
					this.hasArrow = true;
					this.click = r;
				},
				statics : {
					handler : {
						create : function (s) {
							return new p.menuButton(s);
						}
					}
				}
			});
	})();
	o.add('dialogui');
	(function () {
		var r = function (z) {
			var C = this;
			C._ || (C._ = {});
			C._['default'] = C._.initValue = z['default'] || '';
			C._.required = z.required || false;
			var A = [C._];
			for (var B = 1; B < arguments.length; B++)
				A.push(arguments[B]);
			A.push(true);
			j.extend.apply(j, A);
			return C._;
		},
		s = {
			build : function (z, A, B) {
				return new p.dialog.textInput(z, A, B);
			}
		},
		t = {
			build : function (z, A, B) {
				return new p.dialog[A.type](z, A, B);
			}
		},
		u = {
			build : function (z, A, B) {
				var C = A.children,
				D,
				E = [],
				F = [];
				for (var G = 0; G < C.length && (D = C[G]); G++) {
					var H = [];
					E.push(H);
					F.push(f.dialog._.uiElementBuilders[D.type].build(z, D, H));
				}
				return new p.dialog[A.type](z, F, E, B, A);
			}
		},
		v = {
			isChanged : function () {
				return this.getValue() != this.getInitValue();
			},
			reset : function (z) {
				this.setValue(this.getInitValue(), z);
			},
			setInitValue : function () {
				this._.initValue = this.getValue();
			},
			resetInitValue : function () {
				this._.initValue = this._['default'];
			},
			getInitValue : function () {
				return this._.initValue;
			}
		},
		w = j.extend({}, p.dialog.uiElement.prototype.eventProcessors, {
				onChange : function (z, A) {
					if (!this._.domOnChangeRegistered) {
						z.on('load', function () {
							this.getInputElement().on('change', function () {
								if (!z.parts.dialog.isVisible())
									return;
								this.fire('change', {
									value : this.getValue()
								});
							}, this);
						}, this);
						this._.domOnChangeRegistered = true;
					}
					this.on('change', A);
				}
			}, true),
		x = /^on([A-Z]\w+)/,
		y = function (z) {
			for (var A in z) {
				if (x.test(A) || A == 'title' || A == 'type')
					delete z[A];
			}
			return z;
		};
		j.extend(p.dialog, {
			labeledElement : function (z, A, B, C) {
				if (arguments.length < 4)
					return;
				var D = r.call(this, A);
				D.labelId = j.getNextId() + '_label';
				var E = this._.children = [],
				F = function () {
					var G = [],
					H = A.required ? ' cke_required' : '';
					if (A.labelLayout != 'horizontal')
						G.push('<label class="cke_dialog_ui_labeled_label' + H + '" ', ' id="' + D.labelId + '"', D.inputId ? ' for="' + D.inputId + '"' : '', (A.labelStyle ? ' style="' + A.labelStyle + '"' : '') + '>', A.label, '</label>', '<div class="cke_dialog_ui_labeled_content"' + (A.controlStyle ? ' style="' + A.controlStyle + '"' : '') + ' role="presentation">', C.call(this, z, A), '</div>');
					else {
						var I = {
							type : 'hbox',
							widths : A.widths,
							padding : 0,
							children : [{
									type : 'html',
									html : '<label class="cke_dialog_ui_labeled_label' + H + '"' + ' id="' + D.labelId + '"' + ' for="' + D.inputId + '"' + (A.labelStyle ? ' style="' + A.labelStyle + '"' : '') + '>' + j.htmlEncode(A.label) + '</span>'
								}, {
									type : 'html',
									html : '<span class="cke_dialog_ui_labeled_content"' + (A.controlStyle ? ' style="' + A.controlStyle + '"' : '') + '>' + C.call(this, z, A) + '</span>'
								}
							]
						};
						f.dialog._.uiElementBuilders.hbox.build(z, I, G);
					}
					return G.join('');
				};
				p.dialog.uiElement.call(this, z, A, B, 'div', null, {
					role : 'presentation'
				}, F);
			},
			textInput : function (z, A, B) {
				if (arguments.length < 3)
					return;
				r.call(this, A);
				var C = this._.inputId = j.getNextId() + '_textInput',
				D = {
					'class' : 'cke_dialog_ui_input_' + A.type,
					id : C,
					type : A.type
				},
				E;
				if (A.validate)
					this.validate = A.validate;
				if (A.maxLength)
					D.maxlength = A.maxLength;
				if (A.size)
					D.size = A.size;
				if (A.inputStyle)
					D.style = A.inputStyle;
				var F = function () {
					var G = ['<div class="cke_dialog_ui_input_', A.type, '" role="presentation"'];
					if (A.width)
						G.push('style="width:' + A.width + '" ');
					G.push('><input ');
					D['aria-labelledby'] = this._.labelId;
					this._.required && (D['aria-required'] = this._.required);
					for (var H in D)
						G.push(H + '="' + D[H] + '" ');
					G.push(' /></div>');
					return G.join('');
				};
				p.dialog.labeledElement.call(this, z, A, B, F);
			},
			textarea : function (z, A, B) {
				if (arguments.length < 3)
					return;
				r.call(this, A);
				var C = this,
				D = this._.inputId = j.getNextId() + '_textarea',
				E = {};
				if (A.validate)
					this.validate = A.validate;
				E.rows = A.rows || 5;
				E.cols = A.cols || 20;
				if (typeof A.inputStyle != 'undefined')
					E.style = A.inputStyle;
				var F = function () {
					E['aria-labelledby'] = this._.labelId;
					this._.required && (E['aria-required'] = this._.required);
					var G = ['<div class="cke_dialog_ui_input_textarea" role="presentation"><textarea class="cke_dialog_ui_input_textarea" id="', D, '" '];
					for (var H in E)
						G.push(H + '="' + j.htmlEncode(E[H]) + '" ');
					G.push('>', j.htmlEncode(C._['default']), '</textarea></div>');
					return G.join('');
				};
				p.dialog.labeledElement.call(this, z, A, B, F);
			},
			checkbox : function (z, A, B) {
				if (arguments.length < 3)
					return;
				var C = r.call(this, A, {
						'default' : !!A['default']
					});
				if (A.validate)
					this.validate = A.validate;
				var D = function () {
					var E = j.extend({}, A, {
							id : A.id ? A.id + '_checkbox' : j.getNextId() + '_checkbox'
						}, true),
					F = [],
					G = j.getNextId() + '_label',
					H = {
						'class' : 'cke_dialog_ui_checkbox_input',
						type : 'checkbox',
						'aria-labelledby' : G
					};
					y(E);
					if (A['default'])
						H.checked = 'checked';
					if (typeof E.inputStyle != 'undefined')
						E.style = E.inputStyle;
					C.checkbox = new p.dialog.uiElement(z, E, F, 'input', null, H);
					F.push(' <label id="', G, '" for="', H.id, '"' + (A.labelStyle ? ' style="' + A.labelStyle + '"' : '') + '>', j.htmlEncode(A.label), '</label>');
					return F.join('');
				};
				p.dialog.uiElement.call(this, z, A, B, 'span', null, null, D);
			},
			radio : function (z, A, B) {
				if (arguments.length < 3)
					return;
				r.call(this, A);
				if (!this._['default'])
					this._['default'] = this._.initValue = A.items[0][1];
				if (A.validate)
					this.validate = A.valdiate;
				var C = [],
				D = this,
				E = function () {
					var F = [],
					G = [],
					H = {
						'class' : 'cke_dialog_ui_radio_item',
						'aria-labelledby' : this._.labelId
					},
					I = A.id ? A.id + '_radio' : j.getNextId() + '_radio';
					for (var J = 0; J < A.items.length; J++) {
						var K = A.items[J],
						L = K[2] !== undefined ? K[2] : K[0],
						M = K[1] !== undefined ? K[1] : K[0],
						N = j.getNextId() + '_radio_input',
						O = N + '_label',
						P = j.extend({}, A, {
								id : N,
								title : null,
								type : null
							}, true),
						Q = j.extend({}, P, {
								title : L
							}, true),
						R = {
							type : 'radio',
							'class' : 'cke_dialog_ui_radio_input',
							name : I,
							value : M,
							'aria-labelledby' : O
						},
						S = [];
						if (D._['default'] == M)
							R.checked = 'checked';
						y(P);
						y(Q);
						if (typeof P.inputStyle != 'undefined')
							P.style = P.inputStyle;
						C.push(new p.dialog.uiElement(z, P, S, 'input', null, R));
						S.push(' ');
						new p.dialog.uiElement(z, Q, S, 'label', null, {
							id : O,
							'for' : R.id
						}, K[0]);
						F.push(S.join(''));
					}
					new p.dialog.hbox(z, C, F, G);
					return G.join('');
				};
				p.dialog.labeledElement.call(this, z, A, B, E);
				this._.children = C;
			},
			button : function (z, A, B) {
				if (!arguments.length)
					return;
				if (typeof A == 'function')
					A = A(z.getParentEditor());
				r.call(this, A, {
					disabled : A.disabled || false
				});
				f.event.implementOn(this);
				var C = this;
				z.on('load', function (F) {
					var G = this.getElement();
					(function () {
						G.on('click', function (H) {
							C.fire('click', {
								dialog : C.getDialog()
							});
							H.data.preventDefault();
						});
						G.on('keydown', function (H) {
							if (H.data.getKeystroke()in {
								32 : 1
							}) {
								C.click();
								H.data.preventDefault();
							}
						});
					})();
					G.unselectable();
				}, this);
				var D = j.extend({}, A);
				delete D.style;
				var E = j.getNextId() + '_label';
				p.dialog.uiElement.call(this, z, D, B, 'a', null, {
					style : A.style,
					href : 'javascript:void(0)',
					title : A.label,
					hidefocus : 'true',
					'class' : A['class'],
					role : 'button',
					'aria-labelledby' : E
				}, '<span id="' + E + '" class="cke_dialog_ui_button">' + j.htmlEncode(A.label) + '</span>');
			},
			select : function (z, A, B) {
				if (arguments.length < 3)
					return;
				var C = r.call(this, A);
				if (A.validate)
					this.validate = A.validate;
				C.inputId = j.getNextId() + '_select';
				var D = function () {
					var E = j.extend({}, A, {
							id : A.id ? A.id + '_select' : j.getNextId() + '_select'
						}, true),
					F = [],
					G = [],
					H = {
						id : C.inputId,
						'class' : 'cke_dialog_ui_input_select',
						'aria-labelledby' : this._.labelId
					};
					if (A.size != undefined)
						H.size = A.size;
					if (A.multiple != undefined)
						H.multiple = A.multiple;
					y(E);
					for (var I = 0, J; I < A.items.length && (J = A.items[I]); I++)
						G.push('<option value="', j.htmlEncode(J[1] !== undefined ? J[1] : J[0]).replace(/"/g, '&quot;'), '" /> ', j.htmlEncode(J[0]));
					if (typeof E.inputStyle != 'undefined')
						E.style = E.inputStyle;
					C.select = new p.dialog.uiElement(z, E, F, 'select', null, H, G.join(''));
					return F.join('');
				};
				p.dialog.labeledElement.call(this, z, A, B, D);
			},
			file : function (z, A, B) {
				if (arguments.length < 3)
					return;
				if (A['default'] === undefined)
					A['default'] = '';
				var C = j.extend(r.call(this, A), {
						definition : A,
						buttons : []
					});
				if (A.validate)
					this.validate = A.validate;
				var D = function () {
					C.frameId = j.getNextId() + '_fileInput';
					var E = g.isCustomDomain(),
					F = ['<iframe frameborder="0" allowtransparency="0" class="cke_dialog_ui_input_file" role="presentation" id="', C.frameId, '" title="', A.label, '" src="javascript:void('];
					F.push(E ? "(function(){document.open();document.domain='" + document.domain + "';" + 'document.close();' + '})()' : '0');
					F.push(')"></iframe>');
					return F.join('');
				};
				z.on('load', function () {
					var E = f.document.getById(C.frameId),
					F = E.getParent();
					F.addClass('cke_dialog_ui_input_file');
				});
				p.dialog.labeledElement.call(this, z, A, B, D);
			},
			fileButton : function (z, A, B) {
				if (arguments.length < 3)
					return;
				var C = r.call(this, A),
				D = this;
				if (A.validate)
					this.validate = A.validate;
				var E = j.extend({}, A),
				F = E.onClick;
				E.className = (E.className ? E.className + ' ' : '') + 'cke_dialog_ui_button';
				E.onClick = function (G) {
					var H = A['for'];
					if (!F || F.call(this, G) !== false) {
						z.getContentElement(H[0], H[1]).submit();
						this.disable();
					}
				};
				z.on('load', function () {
					z.getContentElement(A['for'][0], A['for'][1])._.buttons.push(D);
				});
				p.dialog.button.call(this, z, E, B);
			},
			html : (function () {
				var z = /^\s*<[\w:]+\s+([^>]*)?>/,
				A = /^(\s*<[\w:]+(?:\s+[^>]*)?)((?:.|\r|\n)+)$/,
				B = /\/$/;
				return function (C, D, E) {
					if (arguments.length < 3)
						return;
					var F = [],
					G,
					H = D.html,
					I,
					J;
					if (H.charAt(0) != '<')
						H = '<span>' + H + '</span>';
					var K = D.focus;
					if (K) {
						var L = this.focus;
						this.focus = function () {
							L.call(this);
							typeof K == 'function' && K.call(this);
							this.fire('focus');
						};
						if (D.isFocusable) {
							var M = this.isFocusable;
							this.isFocusable = M;
						}
						this.keyboardFocusable = true;
					}
					p.dialog.uiElement.call(this, C, D, F, 'span', null, null, '');
					G = F.join('');
					I = G.match(z);
					J = H.match(A) || ['', '', ''];
					if (B.test(J[1])) {
						J[1] = J[1].slice(0, -1);
						J[2] = '/' + J[2];
					}
					E.push([J[1], ' ', I[1] || '', J[2]].join(''));
				};
			})(),
			fieldset : function (z, A, B, C, D) {
				var E = D.label,
				F = function () {
					var G = [];
					E && G.push('<legend' + (D.labelStyle ? ' style="' + D.labelStyle + '"' : '') + '>' + E + '</legend>');
					for (var H = 0; H < B.length; H++)
						G.push(B[H]);
					return G.join('');
				};
				this._ = {
					children : A
				};
				p.dialog.uiElement.call(this, z, D, C, 'fieldset', null, null, F);
			}
		}, true);
		p.dialog.html.prototype = new p.dialog.uiElement();
		p.dialog.labeledElement.prototype = j.extend(new p.dialog.uiElement(), {
				setLabel : function (z) {
					var A = f.document.getById(this._.labelId);
					if (A.getChildCount() < 1)
						new i.text(z, f.document).appendTo(A);
					else
						A.getChild(0).$.nodeValue = z;
					return this;
				},
				getLabel : function () {
					var z = f.document.getById(this._.labelId);
					if (!z || z.getChildCount() < 1)
						return '';
					else
						return z.getChild(0).getText();
				},
				eventProcessors : w
			}, true);
		p.dialog.button.prototype = j.extend(new p.dialog.uiElement(), {
				click : function () {
					var z = this;
					if (!z._.disabled)
						return z.fire('click', {
							dialog : z._.dialog
						});
					z.getElement().$.blur();
					return false;
				},
				enable : function () {
					this._.disabled = false;
					var z = this.getElement();
					z && z.removeClass('cke_disabled');
				},
				disable : function () {
					this._.disabled = true;
					this.getElement().addClass('cke_disabled');
				},
				isVisible : function () {
					return this.getElement().getFirst().isVisible();
				},
				isEnabled : function () {
					return !this._.disabled;
				},
				eventProcessors : j.extend({}, p.dialog.uiElement.prototype.eventProcessors, {
					onClick : function (z, A) {
						this.on('click', function () {
							this.getElement().focus();
							A.apply(this, arguments);
						});
					}
				}, true),
				accessKeyUp : function () {
					this.click();
				},
				accessKeyDown : function () {
					this.focus();
				},
				keyboardFocusable : true
			}, true);
		p.dialog.textInput.prototype = j.extend(new p.dialog.labeledElement(), {
				getInputElement : function () {
					return f.document.getById(this._.inputId);
				},
				focus : function () {
					var z = this.selectParentTab();
					setTimeout(function () {
						var A = z.getInputElement();
						A && A.$.focus();
					}, 0);
				},
				select : function () {
					var z = this.selectParentTab();
					setTimeout(function () {
						var A = z.getInputElement();
						if (A) {
							A.$.focus();
							A.$.select();
						}
					}, 0);
				},
				accessKeyUp : function () {
					this.select();
				},
				setValue : function (z) {
					!z && (z = '');
					return p.dialog.uiElement.prototype.setValue.apply(this, arguments);
				},
				keyboardFocusable : true
			}, v, true);
		p.dialog.textarea.prototype = new p.dialog.textInput();
		p.dialog.select.prototype = j.extend(new p.dialog.labeledElement(), {
				getInputElement : function () {
					return this._.select.getElement();
				},
				add : function (z, A, B) {
					var C = new m('option', this.getDialog().getParentEditor().document),
					D = this.getInputElement().$;
					C.$.text = z;
					C.$.value = A === undefined || A === null ? z : A;
					if (B === undefined || B === null) {
						if (h)
							D.add(C.$);
						else
							D.add(C.$, null);
					} else
						D.add(C.$, B);
					return this;
				},
				remove : function (z) {
					var A = this.getInputElement().$;
					A.remove(z);
					return this;
				},
				clear : function () {
					var z = this.getInputElement().$;
					while (z.length > 0)
						z.remove(0);
					return this;
				},
				keyboardFocusable : true
			}, v, true);
		p.dialog.checkbox.prototype = j.extend(new p.dialog.uiElement(), {
				getInputElement : function () {
					return this._.checkbox.getElement();
				},
				setValue : function (z, A) {
					this.getInputElement().$.checked = z;
					!A && this.fire('change', {
						value : z
					});
				},
				getValue : function () {
					return this.getInputElement().$.checked;
				},
				accessKeyUp : function () {
					this.setValue(!this.getValue());
				},
				eventProcessors : {
					onChange : function (z, A) {
						if (!h || g.version > 8)
							return w.onChange.apply(this, arguments);
						else {
							z.on('load', function () {
								var B = this._.checkbox.getElement();
								B.on('propertychange', function (C) {
									C = C.data.$;
									if (C.propertyName == 'checked')
										this.fire('change', {
											value : B.$.checked
										});
								}, this);
							}, this);
							this.on('change', A);
						}
						return null;
					}
				},
				keyboardFocusable : true
			}, v, true);
		p.dialog.radio.prototype = j.extend(new p.dialog.uiElement(), {
				setValue : function (z, A) {
					var B = this._.children,
					C;
					for (var D = 0; D < B.length && (C = B[D]); D++)
						C.getElement().$.checked = C.getValue() == z;
					!A && this.fire('change', {
						value : z
					});
				},
				getValue : function () {
					var z = this._.children;
					for (var A = 0; A < z.length; A++) {
						if (z[A].getElement().$.checked)
							return z[A].getValue();
					}
					return null;
				},
				accessKeyUp : function () {
					var z = this._.children,
					A;
					for (A = 0; A < z.length; A++) {
						if (z[A].getElement().$.checked) {
							z[A].getElement().focus();
							return;
						}
					}
					z[0].getElement().focus();
				},
				eventProcessors : {
					onChange : function (z, A) {
						if (!h)
							return w.onChange.apply(this, arguments);
						else {
							z.on('load', function () {
								var B = this._.children,
								C = this;
								for (var D = 0; D < B.length; D++) {
									var E = B[D].getElement();
									E.on('propertychange', function (F) {
										F = F.data.$;
										if (F.propertyName == 'checked' && this.$.checked)
											C.fire('change', {
												value : this.getAttribute('value')
											});
									});
								}
							}, this);
							this.on('change', A);
						}
						return null;
					}
				},
				keyboardFocusable : true
			}, v, true);
		p.dialog.file.prototype = j.extend(new p.dialog.labeledElement(), v, {
				getInputElement : function () {
					var z = f.document.getById(this._.frameId).getFrameDocument();
					return z.$.forms.length > 0 ? new m(z.$.forms[0].elements[0]) : this.getElement();
				},
				submit : function () {
					this.getInputElement().getParent().$.submit();
					return this;
				},
				getAction : function () {
					return this.getInputElement().getParent().$.action;
				},
				registerEvents : function (z) {
					var A = /^on([A-Z]\w+)/,
					B,
					C = function (E, F, G, H) {
						E.on('formLoaded', function () {
							E.getInputElement().on(G, H, E);
						});
					};
					for (var D in z) {
						if (!(B = D.match(A)))
							continue;
						if (this.eventProcessors[D])
							this.eventProcessors[D].call(this, this._.dialog, z[D]);
						else
							C(this, this._.dialog, B[1].toLowerCase(), z[D]);
					}
					return this;
				},
				reset : function () {
					var z = this._,
					A = f.document.getById(z.frameId),
					B = A.getFrameDocument(),
					C = z.definition,
					D = z.buttons,
					E = this.formLoadedNumber,
					F = this.formUnloadNumber,
					G = z.dialog._.editor.lang.dir,
					H = z.dialog._.editor.langCode;
					if (!E) {
						E = this.formLoadedNumber = j.addFunction(function () {
								this.fire('formLoaded');
							}, this);
						F = this.formUnloadNumber = j.addFunction(function () {
								this.getInputElement().clearCustomData();
							}, this);
						this.getDialog()._.editor.on('destroy', function () {
							j.removeFunction(E);
							j.removeFunction(F);
						});
					}
					function I() {
						B.$.open();
						if (g.isCustomDomain())
							B.$.domain = document.domain;
						var J = '';
						if (C.size)
							J = C.size - (h ? 7 : 0);
						var K = z.frameId + '_input';
						B.$.write(['<html dir="' + G + '" lang="' + H + '"><head><title></title></head><body style="margin: 0; overflow: hidden; background: transparent;">', '<form enctype="multipart/form-data" method="POST" dir="' + G + '" lang="' + H + '" action="', j.htmlEncode(C.action), '">', '<label id="', z.labelId, '" for="', K, '" style="display:none">', j.htmlEncode(C.label), '</label>', '<input id="', K, '" aria-labelledby="', z.labelId, '" type="file" name="', j.htmlEncode(C.id || 'cke_upload'), '" size="', j.htmlEncode(J > 0 ? J : ''), '" />', '</form>', '</body></html>', '<script>window.parent.CKEDITOR.tools.callFunction(' + E + ');', 'window.onbeforeunload = function() {window.parent.CKEDITOR.tools.callFunction(' + F + ')}</script>'].join(''));
						B.$.close();
						for (var L = 0; L < D.length; L++)
							D[L].enable();
					};
					if (g.gecko)
						setTimeout(I, 500);
					else
						I();
				},
				getValue : function () {
					return this.getInputElement().$.value || '';
				},
				setInitValue : function () {
					this._.initValue = '';
				},
				eventProcessors : {
					onChange : function (z, A) {
						if (!this._.domOnChangeRegistered) {
							this.on('formLoaded', function () {
								this.getInputElement().on('change', function () {
									this.fire('change', {
										value : this.getValue()
									});
								}, this);
							}, this);
							this._.domOnChangeRegistered = true;
						}
						this.on('change', A);
					}
				},
				keyboardFocusable : true
			}, true);
		p.dialog.fileButton.prototype = new p.dialog.button();
		p.dialog.fieldset.prototype = j.clone(p.dialog.hbox.prototype);
		f.dialog.addUIElement('text', s);
		f.dialog.addUIElement('password', s);
		f.dialog.addUIElement('textarea', t);
		f.dialog.addUIElement('checkbox', t);
		f.dialog.addUIElement('radio', t);
		f.dialog.addUIElement('button', t);
		f.dialog.addUIElement('select', t);
		f.dialog.addUIElement('file', t);
		f.dialog.addUIElement('fileButton', t);
		f.dialog.addUIElement('html', t);
		f.dialog.addUIElement('fieldset', u);
	})();
	o.add('panel', {
		beforeInit : function (r) {
			r.ui.addHandler(2, p.panel.handler);
		}
	});
	f.UI_PANEL = 'panel';
	p.panel = function (r, s) {
		var t = this;
		if (s)
			j.extend(t, s);
		j.extend(t, {
			className : '',
			css : []
		});
		t.id = j.getNextId();
		t.document = r;
		t._ = {
			blocks : {}
			
		};
	};
	p.panel.handler = {
		create : function (r) {
			return new p.panel(r);
		}
	};
	p.panel.prototype = {
		renderHtml : function (r) {
			var s = [];
			this.render(r, s);
			return s.join('');
		},
		render : function (r, s) {
			var u = this;
			var t = u.id;
			s.push('<div class="', r.skinClass, '" lang="', r.langCode, '" role="presentation" style="display:none;z-index:' + (r.config.baseFloatZIndex + 1) + '">' + '<div' + ' id=', t, ' dir=', r.lang.dir, ' role="presentation" class="cke_panel cke_', r.lang.dir);
			if (u.className)
				s.push(' ', u.className);
			s.push('">');
			if (u.forceIFrame || u.css.length) {
				s.push('<iframe id="', t, '_frame" frameborder="0" role="application" src="javascript:void(');
				s.push(g.isCustomDomain() ? "(function(){document.open();document.domain='" + document.domain + "';" + 'document.close();' + '})()' : '0');
				s.push(')"></iframe>');
			}
			s.push('</div></div>');
			return t;
		},
		getHolderElement : function () {
			var r = this._.holder;
			if (!r) {
				if (this.forceIFrame || this.css.length) {
					var s = this.document.getById(this.id + '_frame'),
					t = s.getParent(),
					u = t.getAttribute('dir'),
					v = t.getParent().getAttribute('class'),
					w = t.getParent().getAttribute('lang'),
					x = s.getFrameDocument();
					g.iOS && t.setStyles({
						overflow : 'scroll',
						'-webkit-overflow-scrolling' : 'touch'
					});
					var y = j.addFunction(j.bind(function (B) {
								this.isLoaded = true;
								if (this.onLoad)
									this.onLoad();
							}, this)),
					z = '<!DOCTYPE html><html dir="' + u + '" class="' + v + '_container" lang="' + w + '">' + '<head>' + '<style>.' + v + '_container{visibility:hidden}</style>' + j.buildStyleHtml(this.css) + '</head>' + '<body class="cke_' + u + ' cke_panel_frame ' + g.cssClass + '" style="margin:0;padding:0"' + ' onload="( window.CKEDITOR || window.parent.CKEDITOR ).tools.callFunction(' + y + ');"></body>' + '</html>';
					x.write(z);
					var A = x.getWindow();
					A.$.CKEDITOR = f;
					x.on('key' + (g.opera ? 'press' : 'down'), function (B) {
						var E = this;
						var C = B.data.getKeystroke(),
						D = E.document.getById(E.id).getAttribute('dir');
						if (E._.onKeyDown && E._.onKeyDown(C) === false) {
							B.data.preventDefault();
							return;
						}
						if (C == 27 || C == (D == 'rtl' ? 39 : 37))
							if (E.onEscape && E.onEscape(C) === false)
								B.data.preventDefault();
					}, this);
					r = x.getBody();
					r.unselectable();
					g.air && j.callFunction(y);
				} else
					r = this.document.getById(this.id);
				this._.holder = r;
			}
			return r;
		},
		addBlock : function (r, s) {
			var t = this;
			s = t._.blocks[r] = s instanceof p.panel.block ? s : new p.panel.block(t.getHolderElement(), s);
			if (!t._.currentBlock)
				t.showBlock(r);
			return s;
		},
		getBlock : function (r) {
			return this._.blocks[r];
		},
		showBlock : function (r) {
			var w = this;
			var s = w._.blocks,
			t = s[r],
			u = w._.currentBlock,
			v = !w.forceIFrame || h ? w._.holder : w.document.getById(w.id + '_frame');
			if (u) {
				v.removeAttributes(u.attributes);
				u.hide();
			}
			w._.currentBlock = t;
			v.setAttributes(t.attributes);
			f.fire('ariaWidget', v);
			t._.focusIndex = -1;
			w._.onKeyDown = t.onKeyDown && j.bind(t.onKeyDown, t);
			t.show();
			return t;
		},
		destroy : function () {
			this.element && this.element.remove();
		}
	};
	p.panel.block = j.createClass({
			$ : function (r, s) {
				var t = this;
				t.element = r.append(r.getDocument().createElement('div', {
							attributes : {
								tabIndex : -1,
								'class' : 'cke_panel_block',
								role : 'presentation'
							},
							styles : {
								display : 'none'
							}
						}));
				if (s)
					j.extend(t, s);
				if (!t.attributes.title)
					t.attributes.title = t.attributes['aria-label'];
				t.keys = {};
				t._.focusIndex = -1;
				t.element.disableContextMenu();
			},
			_ : {
				markItem : function (r) {
					var u = this;
					if (r == -1)
						return;
					var s = u.element.getElementsByTag('a'),
					t = s.getItem(u._.focusIndex = r);
					if (g.webkit || g.opera)
						t.getDocument().getWindow().focus();
					t.focus();
					u.onMark && u.onMark(t);
				}
			},
			proto : {
				show : function () {
					this.element.setStyle('display', '');
				},
				hide : function () {
					var r = this;
					if (!r.onHide || r.onHide.call(r) !== true)
						r.element.setStyle('display', 'none');
				},
				onKeyDown : function (r) {
					var w = this;
					var s = w.keys[r];
					switch (s) {
					case 'next':
						var t = w._.focusIndex,
						u = w.element.getElementsByTag('a'),
						v;
						while (v = u.getItem(++t)) {
							if (v.getAttribute('_cke_focus') && v.$.offsetWidth) {
								w._.focusIndex = t;
								v.focus();
								break;
							}
						}
						return false;
					case 'prev':
						t = w._.focusIndex;
						u = w.element.getElementsByTag('a');
						while (t > 0 && (v = u.getItem(--t))) {
							if (v.getAttribute('_cke_focus') && v.$.offsetWidth) {
								w._.focusIndex = t;
								v.focus();
								break;
							}
						}
						return false;
					case 'click':
					case 'mouseup':
						t = w._.focusIndex;
						v = t >= 0 && w.element.getElementsByTag('a').getItem(t);
						if (v)
							v.$[s] ? v.$[s]() : v.$['on' + s]();
						return false;
					}
					return true;
				}
			}
		});
	o.add('listblock', {
		requires : ['panel'],
		onLoad : function () {
			p.panel.prototype.addListBlock = function (r, s) {
				return this.addBlock(r, new p.listBlock(this.getHolderElement(), s));
			};
			p.listBlock = j.createClass({
					base : p.panel.block,
					$ : function (r, s) {
						var v = this;
						s = s || {};
						var t = s.attributes || (s.attributes = {});
						(v.multiSelect = !!s.multiSelect) && (t['aria-multiselectable'] = true);
						!t.role && (t.role = 'listbox');
						v.base.apply(v, arguments);
						var u = v.keys;
						u[40] = 'next';
						u[9] = 'next';
						u[38] = 'prev';
						u[2000 + 9] = 'prev';
						u[32] = h ? 'mouseup' : 'click';
						h && (u[13] = 'mouseup');
						v._.pendingHtml = [];
						v._.items = {};
						v._.groups = {};
					},
					_ : {
						close : function () {
							if (this._.started) {
								this._.pendingHtml.push('</ul>');
								delete this._.started;
							}
						},
						getClick : function () {
							if (!this._.click)
								this._.click = j.addFunction(function (r) {
										var t = this;
										var s = true;
										if (t.multiSelect)
											s = t.toggle(r);
										else
											t.mark(r);
										if (t.onClick)
											t.onClick(r, s);
									}, this);
							return this._.click;
						}
					},
					proto : {
						add : function (r, s, t) {
							var w = this;
							var u = w._.pendingHtml,
							v = j.getNextId();
							if (!w._.started) {
								u.push('<ul role="presentation" class=cke_panel_list>');
								w._.started = 1;
								w._.size = w._.size || 0;
							}
							w._.items[r] = v;
							u.push('<li id=', v, ' class=cke_panel_listItem role=presentation><a id="', v, '_option" _cke_focus=1 hidefocus=true title="', t || r, '" href="javascript:void(\'', r, "')\" " + (h ? 'onclick="return false;" onmouseup' : 'onclick') + '="CKEDITOR.tools.callFunction(', w._.getClick(), ",'", r, "'); return false;\"", ' role="option">', s || r, '</a></li>');
						},
						startGroup : function (r) {
							this._.close();
							var s = j.getNextId();
							this._.groups[r] = s;
							this._.pendingHtml.push('<h1 role="presentation" id=', s, ' class=cke_panel_grouptitle>', r, '</h1>');
						},
						commit : function () {
							var r = this;
							r._.close();
							r.element.appendHtml(r._.pendingHtml.join(''));
							delete r._.size;
							r._.pendingHtml = [];
						},
						toggle : function (r) {
							var s = this.isMarked(r);
							if (s)
								this.unmark(r);
							else
								this.mark(r);
							return !s;
						},
						hideGroup : function (r) {
							var s = this.element.getDocument().getById(this._.groups[r]),
							t = s && s.getNext();
							if (s) {
								s.setStyle('display', 'none');
								if (t && t.getName() == 'ul')
									t.setStyle('display', 'none');
							}
						},
						hideItem : function (r) {
							this.element.getDocument().getById(this._.items[r]).setStyle('display', 'none');
						},
						showAll : function () {
							var r = this._.items,
							s = this._.groups,
							t = this.element.getDocument();
							for (var u in r)
								t.getById(r[u]).setStyle('display', '');
							for (var v in s) {
								var w = t.getById(s[v]),
								x = w.getNext();
								w.setStyle('display', '');
								if (x && x.getName() == 'ul')
									x.setStyle('display', '');
							}
						},
						mark : function (r) {
							var u = this;
							if (!u.multiSelect)
								u.unmarkAll();
							var s = u._.items[r],
							t = u.element.getDocument().getById(s);
							t.addClass('cke_selected');
							u.element.getDocument().getById(s + '_option').setAttribute('aria-selected', true);
							u.onMark && u.onMark(t);
						},
						unmark : function (r) {
							var v = this;
							var s = v.element.getDocument(),
							t = v._.items[r],
							u = s.getById(t);
							u.removeClass('cke_selected');
							s.getById(t + '_option').removeAttribute('aria-selected');
							v.onUnmark && v.onUnmark(u);
						},
						unmarkAll : function () {
							var v = this;
							var r = v._.items,
							s = v.element.getDocument();
							for (var t in r) {
								var u = r[t];
								s.getById(u).removeClass('cke_selected');
								s.getById(u + '_option').removeAttribute('aria-selected');
							}
							v.onUnmark && v.onUnmark();
						},
						isMarked : function (r) {
							return this.element.getDocument().getById(this._.items[r]).hasClass('cke_selected');
						},
						focus : function (r) {
							this._.focusIndex = -1;
							if (r) {
								var s = this.element.getDocument().getById(this._.items[r]).getFirst(),
								t = this.element.getElementsByTag('a'),
								u,
								v = -1;
								while (u = t.getItem(++v)) {
									if (u.equals(s)) {
										this._.focusIndex = v;
										break;
									}
								}
								setTimeout(function () {
									s.focus();
								}, 0);
							}
						}
					}
				});
		}
	});
	f.themes.add('default', (function () {
			function r(s, t) {
				var u,
				v;
				v = s.config.sharedSpaces;
				v = v && v[t];
				v = v && f.document.getById(v);
				if (v) {
					var w = '<span class="cke_shared"><span class="' + s.skinClass + ' ' + s.id + ' cke_editor_' + s.name + '">' + '<span class="' + g.cssClass + '">' + '<span class="cke_wrapper cke_' + s.lang.dir + '">' + '<span class="cke_editor">' + '<div class="cke_' + t + '">' + '</div></span></span></span></span></span>',
					x = v.append(m.createFromHtml(w, v.getDocument()));
					if (v.getCustomData('cke_hasshared'))
						x.hide();
					else
						v.setCustomData('cke_hasshared', 1);
					u = x.getChild([0, 0, 0, 0]);
					!s.sharedSpaces && (s.sharedSpaces = {});
					s.sharedSpaces[t] = u;
					s.on('focus', function () {
						for (var y = 0, z, A = v.getChildren(); z = A.getItem(y); y++) {
							if (z.type == 1 && !z.equals(x) && z.hasClass('cke_shared'))
								z.hide();
						}
						x.show();
					});
					s.on('destroy', function () {
						x.remove();
					});
				}
				return u;
			};
			return {
				build : function (s, t) {
					var u = s.name,
					v = s.element,
					w = s.elementMode;
					if (!v || w == 0)
						return;
					if (w == 1)
						v.hide();
					var x = s.fire('themeSpace', {
							space : 'top',
							html : ''
						}).html,
					y = s.fire('themeSpace', {
							space : 'contents',
							html : ''
						}).html,
					z = s.fireOnce('themeSpace', {
							space : 'bottom',
							html : ''
						}).html,
					A = y && s.config.height,
					B = s.config.tabIndex || s.element.getAttribute('tabindex') || 0;
					if (!y)
						A = 'auto';
					else if (!isNaN(A))
						A += 'px';
					var C = '',
					D = s.config.width;
					if (D) {
						if (!isNaN(D))
							D += 'px';
						C += 'width: ' + D + ';';
					}
					var E = x && r(s, 'top'),
					F = r(s, 'bottom');
					E && (E.setHtml(x), x = '');
					F && (F.setHtml(z), z = '');
					var G = m.createFromHtml(['<span id="cke_', u, '" class="', s.skinClass, ' ', s.id, ' cke_editor_', u, '" dir="', s.lang.dir, '" title="', g.gecko ? ' ' : '', '" lang="', s.langCode, '"' + (g.webkit ? ' tabindex="' + B + '"' : '') + ' role="application"' + ' aria-labelledby="cke_', u, '_arialbl"' + (C ? ' style="' + C + '"' : '') + '>' + '<span id="cke_', u, '_arialbl" class="cke_voice_label">' + s.lang.editor + '</span>' + '<span class="', g.cssClass, '" role="presentation"><span class="cke_wrapper cke_', s.lang.dir, '" role="presentation"><table class="cke_editor" border="0" cellspacing="0" cellpadding="0" role="presentation"><tbody><tr', x ? '' : ' style="display:none"', ' role="presentation"><td id="cke_top_', u, '" class="cke_top" role="presentation">', x, '</td></tr><tr', y ? '' : ' style="display:none"', ' role="presentation"><td id="cke_contents_', u, '" class="cke_contents" style="height:', A, '" role="presentation">', y, '</td></tr><tr', z ? '' : ' style="display:none"', ' role="presentation"><td id="cke_bottom_', u, '" class="cke_bottom" role="presentation">', z, '</td></tr></tbody></table><style>.', s.skinClass, '{visibility:hidden;}</style></span></span></span>'].join(''));
					G.getChild([1, 0, 0, 0, 0]).unselectable();
					G.getChild([1, 0, 0, 0, 2]).unselectable();
					if (w == 1)
						G.insertAfter(v);
					else
						v.append(G);
					s.container = G;
					G.disableContextMenu();
					s.fireOnce('themeLoaded');
					s.fireOnce('uiReady');
				},
				buildDialog : function (s) {
					var t = j.getNextNumber(),
					u = m.createFromHtml(['<div class="', s.id, '_dialog cke_editor_', s.name.replace('.', '\\.'), '_dialog cke_skin_', s.skinName, '" dir="', s.lang.dir, '" lang="', s.langCode, '" role="dialog" aria-labelledby="%title#"><table class="cke_dialog', ' ' + g.cssClass, ' cke_', s.lang.dir, '" style="position:absolute" role="presentation"><tr><td role="presentation"><div class="%body" role="presentation"><div id="%title#" class="%title" role="presentation"></div><a id="%close_button#" class="%close_button" href="javascript:void(0)" title="' + s.lang.common.close + '" role="button"><span class="cke_label">X</span></a>' + '<div id="%tabs#" class="%tabs" role="tablist"></div>' + '<table class="%contents" role="presentation">' + '<tr>' + '<td id="%contents#" class="%contents" role="presentation"></td>' + '</tr>' + '<tr>' + '<td id="%footer#" class="%footer" role="presentation"></td>' + '</tr>' + '</table>' + '</div>' + '<div id="%tl#" class="%tl"></div>' + '<div id="%tc#" class="%tc"></div>' + '<div id="%tr#" class="%tr"></div>' + '<div id="%ml#" class="%ml"></div>' + '<div id="%mr#" class="%mr"></div>' + '<div id="%bl#" class="%bl"></div>' + '<div id="%bc#" class="%bc"></div>' + '<div id="%br#" class="%br"></div>' + '</td></tr>' + '</table>', h ? '' : '<style>.cke_dialog{visibility:hidden;}</style>', '</div>'].join('').replace(/#/g, '_' + t).replace(/%/g, 'cke_dialog_')),
					v = u.getChild([0, 0, 0, 0, 0]),
					w = v.getChild(0),
					x = v.getChild(1);
					w.unselectable();
					x.unselectable();
					return {
						element : u,
						parts : {
							dialog : u.getChild(0),
							title : w,
							close : x,
							tabs : v.getChild(2),
							contents : v.getChild([3, 0, 0, 0]),
							footer : v.getChild([3, 0, 1, 0])
						}
					};
				},
				destroy : function (s) {
					var t = s.container;
					t.clearCustomData();
					s.element.clearCustomData();
					if (t)
						t.remove();
					if (s.elementMode == 1)
						s.element.show();
					delete s.element;
				}
			};
		})());
	f.editor.prototype.getThemeSpace = function (r) {
		var s = 'cke_' + r,
		t = this._[s] || (this._[s] = f.document.getById(s + '_' + this.name));
		return t;
	};
	f.editor.prototype.resize = function (r, s, t, u) {
		var v = this.container,
		w = f.document.getById('cke_contents_' + this.name),
		x = u ? v.getChild(1) : v;
		g.webkit && x.setStyle('display', 'none');
		x.setSize('width', r, true);
		if (g.webkit) {
			x.$.offsetWidth;
			x.setStyle('display', '');
		}
		var y = t ? 0 : (x.$.offsetHeight || 0) - (w.$.clientHeight || 0);
		w.setStyle('height', Math.max(s - y, 0) + 'px');
		this.fire('resize');
	};
	f.editor.prototype.getResizable = function () {
		return this.container.getChild(1);
	};
	(function () {
		var r = 'ipsautosave';
		o.add(r, {
			init : function (s) {
				var t = {
					modes : {
						wysiwyg : 1,
						source : 1
					},
					editorFocus : false,
					canUndo : false,
					exec : function (x) {
						if (x.config.ips_AutoSaveKey)
							ipb.textEditor.getEditor().save(x, v);
					}
				},
				u = r,
				v = s.addCommand(u, t);
				s.ui.addButton('Ipsautosave', {
					label : s.lang.ajaxAutoSaveButtonLabel,
					command : u,
					icon : this.path + 'images/autosave.gif'
				});
				var w = setInterval(function () {
						if (s.checkDirty()) {
							s.execCommand(u);
							v.setState(0);
						}
					}, s.config.autoAjaxSaveInterval || 120000);
				s.on('destroy', function () {
					clearInterval(w);
				});
			}
		});
	})();
	o.add('ipsbbcode', {
		init : function (r) {
			var s = this.path,
			t = 'ipsbbcode';
			f.dialog.add(t, this.path + 'dialogs/ipsbbcode.js');
			r.addCommand(t, new f.dialogCommand(t));
			r.ui.addButton('Ipsbbcode', {
				label : ipb.lang.ckeditor__bbcode,
				command : t,
				icon : this.path + 'images/ips_bbcode.png'
			});
			$H(r.config.IPS_BBCODE).each(function (u) {
				var v = u.key,
				w = u.value;
				if (w.image && w.image != '') {
					r.ui.addButton('Ipsbbcode_' + w.tag, {
						label : w.title,
						command : 'ipsbbcode_' + w.tag,
						icon : r.config.IPS_BBCODE_IMG_URL + '/' + w.image
					});
					f.dialog.add('ipsbbcode_' + w.tag, s + 'dialogs/ipsbbcode.js');
					r.addCommand('ipsbbcode_' + w.tag, new f.dialogCommand('ipsbbcode_' + w.tag));
					if (r.config.IPS_BBCODE_BUTTONS.indexOf('Ipsbbcode_' + w.tag) == -1)
						r.config.IPS_BBCODE_BUTTONS.push('Ipsbbcode_' + w.tag);
				}
			});
		}
	});
	(function () {
		var r = {
			exec : function (s) {
				var t = IPSCKTools.getSelectionHtml(s),
				u = new m('span');
				if (t != '') {
					t = t.replace(/<\/div><div([^>]+?)?>/g, '\n');
					t = t.replace(/(<br([^>]+?)?>)?<\/p><p([^>]+?)?>/g, '\n');
					t = t.replace(/<br([^>]+?)?>/g, '\n').stripTags();
					s.insertHtml('<p></p><pre class="_prettyXprint">' + IPSCKTools.cleanHtmlForTagWrap(t) + '\r\n&nbsp;</pre><p></p>');
				} else
					s.openDialog('ipscode');
				return true;
			}
		};
		o.add('ipscode', {
			init : function (s) {
				var t = 'ipscode',
				u = s.addCommand(t, r);
				s.ui.addButton('Ipscode', {
					label : ipb.lang.ckeditor__codelabel,
					command : t,
					icon : this.path + 'images/code.png'
				});
				f.dialog.add(t, f.getUrl(this.path + 'dialogs/ipscode.js'));
				if (s.config.forcePasteAsPlainText) {
					s.on('beforeCommandExec', function (v) {
						var w = v.data.commandData;
						if (v.data.name == 'paste' && w != 'html') {
							s.execCommand('pastetext');
							v.cancel();
						}
					}, null, null, 0);
					s.on('beforePaste', function (v) {
						v.data.mode = 'text';
					});
				}
				s.on('pasteState', function (v) {
					s.getCommand('pastetext').setState(v.data);
				});
			},
			requires : ['clipboard']
		});
	})();
	o.add('ipsmedia', {
		init : function (r) {
			var s = 'ipsmedia',
			t = r.addCommand(s, o.ipsmedia);
			if (inACP) {
				ipb.vars._base_url = ipb.vars.front_url;
				ipb.vars._secure_hash = ipb.vars.md5_hash;
			} else {
				ipb.vars._base_url = ipb.vars.base_url;
				ipb.vars._secure_hash = ipb.vars.secure_hash;
			}
			if (ipb.vars.member_id)
				r.ui.addButton('Ipsmedia', {
					label : ipb.lang.ckeditor__mymedia,
					command : s,
					icon : this.path + 'images/mymedia.png'
				});
		}
	});
	o.ipsmedia = {
		loadTab : function (r, s) {
			$$('#mymedia_tabs li').each(function (v) {
				$(v).removeClassName('active');
			});
			$(r + '_' + s).addClassName('active');
			$('mymedia_toolbar').show();
			$('sharedmedia_search_app').value = r;
			$('sharedmedia_search_plugin').value = s;
			var t = $('sharedmedia_search').value;
			if (t == ipb.vars.sm_init_value)
				t = '';
			var u = ipb.vars._base_url + 'app=core&module=ajax&section=media&do=loadtab&tabapp=' + r + '&tabplugin=' + s;
			new Ajax.Request(u.replace(/&amp;/g, '&'), {
				method : 'post',
				parameters : {
					md5check : ipb.vars._secure_hash,
					search : t
				},
				onSuccess : function (v) {
					$('mymedia_content').update(v.responseText);
				}
			});
			return false;
		},
		exec : function (r) {
			if (!Object.isUndefined(o.ipsmedia.popup))
				o.ipsmedia.popup.kill();
			o.ipsmedia.selectedText = IPSCKTools.getSelectionHtml(r);
			var s = ipb.vars._base_url + 'app=core&module=ajax&section=media&secure_key=' + ipb.vars._secure_hash;
			o.ipsmedia.mediaEditor = r;
			new Ajax.Request(s.replace(/&amp;/g, '&'), {
				method : 'get',
				evalJSON : 'force',
				onSuccess : function (t) {
					o.ipsmedia.popup = new ipb.Popup('my_media_inline', {
							type : 'pane',
							initial : t.responseJSON.html,
							hideAtStart : false,
							hideClose : true,
							defer : false,
							modal : true,
							w : '800px',
							h : '410'
						});
				}
			});
		},
		insert : function (r) {
			var s = o.ipsmedia.selectedText,
			t = new m('div');
			if (s != '') {
				t.setHtml('[sharedmedia=' + r + ']' + IPSCKTools.cleanHtmlForTagWrap(s));
				o.ipsmedia.mediaEditor.insertElement(t);
			} else {
				t.setHtml('[sharedmedia=' + r + ']');
				o.ipsmedia.mediaEditor.insertElement(t);
			}
			$('mymedia_inserted').show().fade({
				duration : 0.3,
				delay : 2
			});
			return false;
		},
		search : function () {
			var r = $('sharedmedia_search').value,
			s = ipb.vars._base_url + 'app=core&module=ajax&section=media&do=loadtab&tabapp=' + $('sharedmedia_search_app').value + '&tabplugin=' + $('sharedmedia_search_plugin').value;
			new Ajax.Request(s.replace(/&amp;/g, '&'), {
				method : 'post',
				parameters : {
					md5check : ipb.vars._secure_hash,
					search : r
				},
				onSuccess : function (t) {
					$('mymedia_content').update(t.responseText);
				}
			});
			return false;
		},
		searchinit : function () {
			$('sharedmedia_submit').observe('click', function (r) {
				Event.stop(r);
				o.ipsmedia.search();
				return false;
			});
			$('sharedmedia_reset').observe('click', function (r) {
				Event.stop(r);
				$('sharedmedia_search').value = '';
				o.ipsmedia.search();
				$('sharedmedia_search').addClassName('inactive').value = ipb.vars.sm_init_value;
				return false;
			});
			$('sharedmedia_search').observe('focus', function (r) {
				if ($('sharedmedia_search').value == ipb.vars.sm_init_value)
					$('sharedmedia_search').removeClassName('inactive').value = '';
			});
		},
		canUndo : true,
		modes : {
			wysiwyg : 1
		},
		mediaEditor : null
	};
	o.add('ipsoptions', {
		init : function (r) {
			var s = 'ipsoptions',
			t = r.addCommand(s, o.ipsoptions);
			r.ui.addButton('Ipsoptions', {
				label : ipb.lang.ckeditor__options,
				command : s,
				icon : this.path + 'images/ips_options.png'
			});
			r.on('beforePaste', function (u) {
				if (r.config.CmdVAsPlainText === true)
					u.data.mode = 'text';
			});
			r.on('paste', function (u) {
				if (r.config.CmdVAsPlainText !== true && typeof u.data.html != 'undefined')
					u.data.html = u.data.html.replace(/<pre([^>]+?)>/g, '').replace(/<\/pre>/g, '').replace(/\n/g, '<br />').replace(/\t/g, '&nbsp;&nbsp;&nbsp;&nbsp;');
			}, null, null, 9);
		},
		requires : ['clipboard']
	});
	o.ipsoptions = {
		exec : function (r) {
			if (!Object.isUndefined(o.ipsoptions.popup))
				o.ipsoptions.popup.kill();
			var s = ipb.textEditor.ajaxUrl + 'app=core&module=ajax&section=editor&do=showSettings&secure_key=' + ipb.vars.secure_hash;
			new Ajax.Request(s.replace(/&amp;/g, '&'), {
				method : 'get',
				evalJSON : 'force',
				onSuccess : function (t) {
					o.ipsoptions.popup = new ipb.Popup('options_popup', {
							type : 'pane',
							initial : t.responseText,
							hideAtStart : false,
							hideClose : false,
							defer : false,
							modal : true,
							w : '260px',
							h : '170'
						});
					$('ipsEditorOptionsSave').observe('click', o.ipsoptions.saveIt.bindAsEventListener(r));
				}
			});
		},
		saveIt : function (r, s) {
			Event.stop(r);
			var t = ipb.textEditor.ajaxUrl + 'app=core&module=ajax&section=editor&do=saveSettings&secure_key=' + ipb.vars.secure_hash;
			new Ajax.Request(t.replace(/&amp;/g, '&'), {
				method : 'post',
				evalJSON : 'force',
				parameters : {
					pastePlain : $F('pastePlain'),
					clearSavedContent : $F('clearSavedContent')
				},
				onSuccess : function (u) {
					if (u.responseJSON.error == 'nopermission' || u.responseJSON.error == 'no_permission')
						ipb.global.errorDialogue(ipb.lang.no_permission);
					else {
						o.ipsoptions.popup.hide();
						if ($F('clearSavedContent') == 1)
							try {
								var v = '__last_update_stamp_' + ipb.textEditor.getCurrentEditorId(),
								w = $$('._as_launch').first().up('.cke_path');
								$$('.' + v).invoke('remove');
								w.remove();
							} catch (x) {}
							
						ipb.global.showInlineNotification(ipb.lang.editor_prefs_updated);
						$('ipsEditorOptionsSave').stopObserving();
					}
				},
				onFailure : function (u, v) {
					Debug.error(v);
				}
			});
		},
		modes : {
			wysiwyg : 1,
			source : 1
		}
	};
	o.add('ipsquote', {
		init : function (r) {
			var s = 'ipsquote',
			t = r.addCommand(s, o.ipsquote);
			r.ui.addButton('Ipsquote', {
				label : ipb.lang.ckeditor__quotelabel,
				command : s,
				icon : this.path + 'images/quote.png'
			});
		}
	});
	o.ipsquote = {
		exec : function (r) {
			var s = new i.selection(r.document);
			text = IPSCKTools.getSelectionHtml(r);
			if (text == '') {}
			
			if (text.substr(0, 4) == '<li>') {
				var t = s.getCommonAncestor();
				para = m.createFromHtml('<p>&nbsp;</p>');
				t.insertBeforeMe(para);
				m.createFromHtml('<p>&nbsp;</p>').insertAfter(para);
				t.move(para);
				s.selectElement(para);
				text = IPSCKTools.getSelectionHtml(r);
			}
			blockquote = m.createFromHtml('<blockquote class="ipsBlockquote"><p>' + IPSCKTools.cleanHtmlForTagWrap(text) + '</p></blockquote>');
			cite = m.createFromHtml('<cite class="ipb" contenteditable="false">' + ipb.lang.ckeditor__quotelabel + '</cite>');
			blockquote.append(cite, true);
			r.insertElement(blockquote);
			range = new i.range(r.document);
			range.moveToElementEditEnd(blockquote.getLast());
			ranges = [range];
			s.selectRanges(ranges);
			ipb.textEditor.makeQuoteEventHandlers(r);
		},
		canUndo : true,
		modes : {
			wysiwyg : 1
		}
	};
	var a = false;
	o.add('ipssourcearea', {
		requires : ['editingblock'],
		init : function (r) {
			var s = o.ipssourcearea,
			t = f.document.getWindow();
			r.on('editingBlockReady', function () {
				var u,
				v;
				r.addMode('ipssource', {
					load : function (w, x) {
						if (h && g.version < 8)
							w.setStyle('position', 'relative');
						r.textarea = u = new m('textarea');
						u.setAttributes({
							dir : 'ltr',
							tabIndex : g.webkit ? -1 : r.tabIndex,
							role : 'textbox',
							'aria-label' : r.lang.editorTitle.replace('%1', r.name)
						});
						u.addClass('cke_source');
						u.addClass('cke_enable_context_menu');
						r.readOnly && u.setAttribute('readOnly', 'readonly');
						var y = {
							width : g.ie7Compat ? '99%' : '100%',
							height : '100%',
							resize : 'none',
							outline : 'none',
							'text-align' : 'left'
						};
						if (h) {
							v = function () {
								u.hide();
								u.setStyle('height', w.$.clientHeight + 'px');
								u.setStyle('width', w.$.clientWidth + 'px');
								u.show();
							};
							r.on('resize', v);
							t.on('resize', v);
							setTimeout(v, 0);
						}
						w.setHtml('');
						w.append(u);
						u.setStyles(y);
						r.fire('ariaWidget', u);
						u.on('blur', function () {
							r.focusManager.blur();
						});
						u.on('focus', function () {
							r.focusManager.focus();
						});
						r.mayBeDirty = true;
						this.loadData(x);
						var z = r.keystrokeHandler;
						if (z)
							z.attach(u);
						setTimeout(function () {
							r.mode = 'ipssource';
							r.fire('mode', {
								previousMode : r._.previousMode
							});
						}, g.gecko || g.webkit ? 100 : 0);
					},
					loadData : function (w) {
						u.setValue(r.ipsOptions.isHtml ? w : myParser.toBBCode(w));
						r.fire('dataReady');
					},
					getData : function () {
						if (parseInt(r.ipsOptions.isHtml) == 1)
							return u.getValue();
						else
							return r.dataProcessor.toHtml(myParser.toHTML(u.getValue()));
					},
					getSnapshotData : function () {
						return u.getValue();
					},
					unload : function (w) {
						u.clearCustomData();
						r.textarea = u = null;
						if (v) {
							r.removeListener('resize', v);
							t.removeListener('resize', v);
						}
						if (h && g.version < 8)
							w.removeStyle('position');
					},
					focus : function () {
						u.focus();
					}
				});
			});
			r.on('readOnly', function () {
				if (r.mode == 'ipssource')
					if (r.readOnly)
						r.textarea.setAttribute('readOnly', 'readonly');
					else
						r.textarea.removeAttribute('readOnly');
			});
			r.addCommand('ipssource', s.commands.ipssource);
			if (r.ui.addButton)
				r.ui.addButton('Ipssource', {
					label : r.lang.source,
					command : 'ipssource',
					icon : this.path + 'images/switch.png'
				});
			r.on('mode', function () {
				r.getCommand('ipssource').setState(r.mode == 'ipssource' ? 1 : 2);
			});
			r.on('dataReady', function () {
				if (r.ipsOptions.startIsRte == 'source') {
					r.ipsOptions.startIsRte = false;
					r.setMode('ipssource');
				}
			});
		}
	});
	function b(r) {
		if (r.mode != 'ipssource')
			return true;
		var s = [],
		t = [],
		u = $('cke_contents_' + r.name).down('textarea').value,
		v = forceCheck === true ? true : false;
		ipsBbcodeTags.each(function (x) {
			if (myParser.options.tagsSingle.indexOf(x) == -1)
				s.push(x);
			else
				Debug.write('Skipping: ' + x);
		});
		IPS_DEFAULT_TAGS.each(function (x) {
			if (myParser.options.tagsSingle.indexOf(x) == -1 && x != '*')
				s.push(x);
			else
				Debug.write('Skipping: ' + x);
		});
		Debug.dir(s);
		var w = u.toLowerCase();
		s.each(function (x) {
			var y = phpjs.substr_count(w, '[' + x + ']') + phpjs.substr_count(w, '[' + x + '='),
			z = phpjs.substr_count(w, '[/' + x + ']');
			Debug.write(x + ' = opening: ' + y + ' closing: ' + z);
			if (y > 0 && y != z)
				t.push(x);
		});
		u = u.replace(/(\r\n|\r|\n)/g, '<br />');
		if (t.length > 0) {
			t.each(function (x) {
				u = u.replace(new RegExp('\\[' + x + '(=[^\\]]+?)?\\]', 'gi'), '<span class="bbcode_hilight">[' + x + '$1]</span>');
				u = u.replace(new RegExp('\\[/' + x + '\\]', 'gi'), '<span class="bbcode_hilight">[/' + x + ']</span>');
			});
			if (a !== false)
				a.kill();
			a = new ipb.Popup('bbcode_Error', {
					type : 'modal',
					initial : new Template(ipb.textEditor.IPS_BBCODE_ERROR).evaluate({
						content : u,
						tags : t.join(', ')
					}),
					stem : false,
					warning : false,
					hideAtStart : false,
					modal : true,
					w : '600px'
				});
			ipb.delegate.register('._bbcode_use_anyway', e.bind(r));
			ipb.delegate.register('._bbcode_close', d.bind(r));
			return false;
		}
		return true;
	};
	function c(r, s, t) {
		r = r.replace(/(\r\n|\r|\n)/g, '<br />');
		s.each(function (u) {
			r = r.replace(new RegExp('\\[' + u + '(=[^\\]]+?)?\\]', 'gi'), '<span class="bbcode_hilight">[' + u + '$1]</span>');
			r = r.replace(new RegExp('\\[/' + u + '\\]', 'gi'), '<span class="bbcode_hilight">[/' + u + ']</span>');
		});
		if (a !== false)
			a.kill();
		a = new ipb.Popup('bbcode_Error', {
				type : 'modal',
				initial : new Template(ipb.textEditor.IPS_BBCODE_ERROR).evaluate({
					content : r,
					tags : s.join(', ')
				}),
				stem : false,
				warning : false,
				hideAtStart : false,
				modal : true,
				w : '600px'
			});
		ipb.delegate.register('._bbcode_use_anyway', e.bind(t));
		ipb.delegate.register('._bbcode_close', d.bind(t));
	};
	function d(r, s) {
		var t = this;
		a.hide();
	};
	function e(r, s) {
		var t = this;
		setTimeout(function () {
			t.setMode('wysiwyg');
		}, g.gecko || g.webkit ? 100 : 0);
		a.hide();
	};
	o.ipssourcearea = {
		commands : {
			ipssource : {
				modes : {
					wysiwyg : 1,
					ipssource : 1
				},
				editorFocus : false,
				readOnly : 1,
				exec : function (r) {
					r._ipsToggled = true;
					r._ipsBypassBBCodeCheck = typeof r._ipsBypassBBCodeCheck === 'undefined' ? false : r._ipsBypassBBCodeCheck;
					if (r.mode == 'wysiwyg') {
						r.fire('saveSnapshot');
						ipb.textEditor.getEditor(r.name).setIsRte(false);
						if ($('cke_' + r.name + '_stray') != null && $('cke_' + r.name + '_stray').visible())
							$('cke_' + r.name + '_stray').blindUp({
								duration : 0.4,
								afterFinish : o.ipsemoticon.removeShowAllLink()
							});
					} else
						ipb.textEditor.getEditor(r.name).setIsRte(true);
					r.getCommand('ipssource').setState(0);
					if (r.mode == 'ipssource' && r._ipsBypassBBCodeCheck === false) {
						var s = true;
						if (s === false) {
							r.getCommand('ipssource').setState(1);
							r._ipsToggled = false;
							return false;
						}
					}
					r.setMode(r.mode == 'ipssource' ? 'wysiwyg' : 'ipssource');
					r._ipsToggled = false;
				},
				canUndo : false
			}
		}
	};
	(function () {
		o.ipsemoticon = {
			editor : {},
			emoPerPage : 20,
			emoTotalPages : 0,
			emoTotal : 0,
			emoPage : 1,
			emoAll : {
				count : false
			},
			addEmoticon : function (s) {
				imgObj = Event.findElement(s);
				editor = o.ipsemoticon.editor;
				var t = imgObj.readAttribute('src'),
				u = imgObj.readAttribute('alt'),
				v = editor.document.createElement('img', {
						attributes : {
							src : t,
							title : u,
							alt : u,
							'class' : 'bbc_emoticon'
						}
					});
				editor.insertElement(v);
				editor.insertText(' ');
				Event.stop(s);
			},
			createTray : function () {
				var C = this;
				var s = o.ipsemoticon.editor,
				t = $('cke_' + s.name),
				u = new Element('div', {
						id : 'cke_' + s.name + '_stray',
						'class' : 'ipsSmileyTray'
					}).hide();
				t.insert({
					after : u
				});
				C.emoPage = 1;
				C.emoTotalPages = 1;
				if (IPS_smiles.total > C.emoPerPage)
					C.emoTotalPages = Math.ceil(IPS_smiles.total / C.emoPerPage);
				C.populateTray($H(IPS_smiles.emoticons));
				$('cke_' + s.name + '_stray').blindDown({
					duration : 0.4,
					afterFinish : o.ipsemoticon.addShowAllLink()
				});
				C.setUpPrevNext();
				try {
					var v = document.viewport.getDimensions(),
					w = $('cke_' + s.name).getDimensions(),
					x = $('cke_' + s.name).cumulativeScrollOffset(),
					y = $('cke_' + s.name).cumulativeOffset(),
					z = y.top + w.height,
					A = x.top + v.height;
					if (z > A) {
						var B = z - A;
						window.scrollTo(0, x.top + B + 100);
					}
				} catch (D) {
					Debug.error(D);
				}
				ipb.delegate.register('.ipsSmileyTray_next', o.ipsemoticon.fireNext);
				ipb.delegate.register('.ipsSmileyTray_prev', o.ipsemoticon.firePrev);
				ipb.delegate.register('.ipsSmileyTray_all', o.ipsemoticon.fireAll);
				return true;
			},
			setUpPrevNext : function () {
				var s = this;
				if (s.emoPage < s.emoTotalPages)
					$('cke_' + s.editor.name + '_stray').insert(new Element('div', {
							'class' : 'ipsSmileyTray_next'
						}));
				if (s.emoPage > 1)
					$('cke_' + s.editor.name + '_stray').insert(new Element('div', {
							'class' : 'ipsSmileyTray_prev'
						}));
			},
			firePrev : function () {
				if (o.ipsemoticon.emoAll.count === false)
					o.ipsemoticon.getJson(o.ipsemoticon.firePrev);
				else {
					var s = o.ipsemoticon.emoPerPage * (o.ipsemoticon.emoPage - 1) - o.ipsemoticon.emoPerPage;
					o.ipsemoticon.emoPage--;
					o.ipsemoticon.showPage(s);
				}
			},
			fireNext : function () {
				if (o.ipsemoticon.emoAll.count === false)
					o.ipsemoticon.getJson(o.ipsemoticon.fireNext);
				else {
					var s = o.ipsemoticon.emoPerPage * o.ipsemoticon.emoPage;
					o.ipsemoticon.emoPage++;
					o.ipsemoticon.showPage(s);
				}
			},
			fireAll : function (s, t) {
				var u = ipb.vars.base_url + '&app=forums&module=extras&section=legends';
				window.open(u, 'Emo', 'status=0,toolbar=0,location=0,menubar=0,width=300,height=600,scrollbars=yes');
				Event.stop(s);
				return false;
			},
			showPage : function (s) {
				var t = new Hash(),
				u = 0,
				v = 0;
				$H(o.ipsemoticon.emoAll.emoticons).each(function (w) {
					var x = w.key,
					y = w.value;
					if (typeof y.src != 'undefined') {
						v++;
						if (s == 0 || v - 1 >= s) {
							u++;
							if (u <= o.ipsemoticon.emoPerPage)
								t.set(x, y);
						}
					}
				});
				$('cke_' + o.ipsemoticon.editor.name + '_stray').select('span').each(function (w) {
					new Effect.Fade(w, {
						duration : 0.2,
						afterFinish : function () {
							o.ipsemoticon.populateTray(t);
							o.ipsemoticon.setUpPrevNext();
						}
					});
				});
			},
			getJson : function (s) {
				o.ipsemoticon.emoAll = IPS_smiles;
				s();
			},
			populateTray : function (s) {
				var t = o.ipsemoticon.editor,
				u = 0;
				$('cke_' + t.name + '_stray').update('');
				s.each(function (v) {
					var w = v.key,
					x = v.value;
					u++;
					if (u <= o.ipsemoticon.emoPerPage && typeof x.src != 'undefined') {
						var y = new Element('img', {
								src : j.htmlEncode(IPS_smiley_path + x.src),
								alt : x.text,
								'class' : 'bbc_emoticon',
								id : 'ipsEmo__' + w
							}),
						z = new Element('span').addClassName('cke_hand').insert(y).hide();
						$('cke_' + t.name + '_stray').insert(z);
						$('ipsEmo__' + w).on('click', o.ipsemoticon.addEmoticon);
					}
				});
				$('cke_' + o.ipsemoticon.editor.name + '_stray').select('span').each(function (v) {
					new Effect.Appear(v, {
						duration : 0.2
					});
				});
			},
			addShowAllLink : function () {
				var s = o.ipsemoticon.editor;
				$('cke_' + s.name + '_stray').insert({
					after : new Element('div', {
						id : 'ips_x_smile_show_all',
						'class' : 'ipsSmileyTray_all'
					}).addClassName('ipsText_smaller').update(ipb.lang.emo_show_all)
				});
			},
			removeShowAllLink : function () {
				$('ips_x_smile_show_all').remove();
			}
		};
		var r = {
			exec : function (s) {
				o.ipsemoticon.editor = s;
				o.ipsemoticon.emoCount = IPS_smiles.emoticons ? IPS_smiles.emoticons.total : 0;
				if ($('cke_' + s.name + '_stray')) {
					if ($('cke_' + s.name + '_stray').visible())
						$('cke_' + s.name + '_stray').blindUp({
							duration : 0.4,
							afterFinish : o.ipsemoticon.removeShowAllLink()
						});
					else
						$('cke_' + s.name + '_stray').blindDown({
							duration : 0.4,
							afterFinish : o.ipsemoticon.addShowAllLink()
						});
				} else
					o.ipsemoticon.createTray();
			}
		};
		o.add('ipsemoticon', {
			init : function (s) {
				var t = 'ipsemoticon',
				u = s.addCommand(t, r);
				s.ui.addButton('Ipsemoticon', {
					label : s.lang.smiley.toolbar,
					command : t,
					icon : this.path + 'images/ips_emoticon.png'
				});
			}
		});
	})();
})();
