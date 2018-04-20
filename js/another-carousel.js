var anotherCarousel = (function() {
    class Carousel {
        constructor(selector) {
        	// Determine click event depending on if we are on Touch device or not
            this._clickEvent = ('ontouchstart' in window) ? 'touchstart' : 'click';

            this.element = typeof selector === 'string' ? document.querySelector(selector) : selector;
            // An invalid selector or non-DOM node has been provided.
            if (!this.element) {
                throw new Error('An invalid selector or non-DOM node has been provided.');
			}
            this.init();
        }

        /**
         * Initiate plugin
         * @method init
         * @return {void}
         */
        init() {
            this.items = Array.from(this.element.querySelectorAll('.a-carousel-item'));
            this.items.forEach((item) => {
                let img = item.querySelector('img');
                img.setAttribute('draggable', false);
            });
            this.computedStyle = window.getComputedStyle(this.element);

            this.previousControl = this.element.querySelector('.a-carousel-nav-left');
            this.nextControl = this.element.querySelector('.a-carousel-nav-right');

            this.leftNav = this.element.querySelector('.a-carousel-navigation.is-left');
			this.rightNav = this.element.querySelector('.a-carousel-navigation.is-right');

            if (this.items.length <= 1) {
                const carouselContainer = this.element.querySelector('.a-carousel-container');
                if (carouselContainer) {
                    carouselContainer.style.left = '0';
                }
                if (this.previousControl) {
                    this.previousControl.style.display = 'none';

                }
                if (this.leftNav) {
                    this.leftNav.style.display = 'none';
                }
                if (this.rightNav) {
                    this.rightNav.style.display = 'none';
                }
                if (this.nextControl) {
                    this.nextControl.style.display = 'none';
                }
			}
			
            this._bindEvents();
			this._initGrid();
			this._setVisible();


		}
		
		_initGrid() {
			const ratioRegex = /\bis-([1-9]+)by([1-9]+)\b/
			const classes = this.element.className;
			const match = classes.match(ratioRegex);
			
			this.nColsVis = parseInt(match[1]);
			this.nRowsVis = parseInt(match[2]);
			this.itemsVis = this.nRowsVis * this.nColsVis;
			this._chunkItems();
			this._setColOrder();
		}
        /**
         * Bind all events
         * @method _bindEvents
         * @return {void}
         */

		_chunkItems() {
			this.cols = [];
			let i = 0;
			let n = this.items.length;
			while(i < n) {
				this.cols.push(this.items.slice(i, i += this.nRowsVis))
			}
			this.nColsReal = this.cols.length;
		}

        _bindEvents() {
            if (this.previousControl) {
                this.previousControl.addEventListener(this._clickEvent, (e) => {
                    e.preventDefault();
                    this._slide('previous');
                    if (this._autoPlayInterval) {
                        clearInterval(this._autoPlayInterval);
                        this._autoPlay(this.element.dataset.delay || 5000);
                    }
                }, false);
            }
            if (this.nextControl) {
                this.nextControl.addEventListener(this._clickEvent, (e) => {
                    e.preventDefault();
                    this._slide('next');
                    if (this._autoPlayInterval) {
                        clearInterval(this._autoPlayInterval);
                        this._autoPlay(this.element.dataset.delay || 5000);
                    }
                }, false);
            }

            // Bind swipe events
            this.element.addEventListener('touchstart', (e) => {
                this._swipeStart(e);
            });
            this.element.addEventListener('mousedown', (e) => {
                this._swipeStart(e);
            });

            this.element.addEventListener('touchend', (e) => {
                this._swipeEnd(e);
            });
            this.element.addEventListener('mouseup', (e) => {
                this._swipeEnd(e);
            });
        }

		_setColOrder() {
			for (var j = 0; j < this.nColsReal; j++) {
				for (var k = 0; k < this.cols[j].length; k++) {
					this.cols[j][k].style.gridColumnStart = j + 1;
					console.log(this.cols[j][k].style);
				}
			}
		}
		
		_setVisible() {
			for (var j = 0; j < this.nColsReal; j++) {
				for (var k = 0; k < this.cols[j].length; k++) {
					if (j < this.nColsVis) {
						this.cols[j][k].style.display = 'block';
					} else {
						this.cols[j][k].style.display = 'none';
					}
				}
			}
		}

        /**
         * Save current position on start swiping
         * @method _swipeStart
         * @param  {Event}    e Swipe event
         * @return {void}
         */
        _swipeStart(e) {
            this._touch = {
                start: {
                    x: e.clientX,
                    y: e.clientY
                },
                end: {
                    x: e.clientX,
                    y: e.clientY
                }
            };
        }

        /**
         * Save current position on end swiping
         * @method _swipeEnd
         * @param  {Event}  e swipe event
         * @return {void}
         */
        _swipeEnd(e) {
            this._touch.end = {
                x: e.clientX,
                y: e.clientY
            };

            this._handleGesture();
        }

        /**
         * Identify the gestureand slide if necessary
         * @method _handleGesture
         * @return {void}
         */
        _handleGesture() {
            const ratio = {
                horizontal: (this._touch.end.x - this._touch.start.x) / parseInt(this.computedStyle.getPropertyValue('width')),
                vertical: (this._touch.end.y - this._touch.start.y) / parseInt(this.computedStyle.getPropertyValue('height'))
            };

            if (ratio.horizontal > ratio.vertical && ratio.horizontal > 0.25) {
                this._slide('previous');
            }

            if (ratio.horizontal < ratio.vertical && ratio.horizontal < -0.25) {
                this._slide('next');
            }
        }

        /**
         * Update slides to display the wanted one
         * @method _slide
         * @param  {String} [direction='next'] Direction in which slide needs to move
         * @return {void}
         */
        _slide(direction = 'next') {
            if (this.items.length) {
                const currentActiveItem = this.element.querySelector('.a-carousel-item.is-active');

				let newActiveItem;

				currentActiveItem.classList.remove('is-active');

                // initialize direction to change order
                if (direction === 'previous') {
					// Reorder items
					
					this.cols.unshift(this.cols.pop());
					
                    // add reverse class
                    this.element.classList.add('is-reversing');
                } else {
					// Reorder items

					this.cols.push(this.cols.shift());
                    // re_slide reverse class
                    this.element.classList.remove('is-reversing');
				}
				newActiveItem = this.cols[0][0];
				
                newActiveItem.classList.add('is-active');
				
				this._setColOrder();
				this._setVisible();
            }
		}
		
    }

    /**
     * Initiate all DOM element containing carousel class
     * @method
     * @return {[type]} [description]
     */
    document.addEventListener('DOMContentLoaded', function() {
        var carousels = document.querySelectorAll('.a-carousel:not(.no-slide)');
        [].forEach.call(carousels, function(carousel) {
            new Carousel(carousel);
        });
    });

    return Carousel;

}());
