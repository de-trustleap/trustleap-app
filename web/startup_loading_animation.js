// Startup Loading Animation JavaScript

// Handle startup loading animation image loading error
function handleImageError() {
  const loadingElement = document.getElementById('flutter-loading');
  const imgElement = document.getElementById('loading-gif');
  if (loadingElement && imgElement) {
    imgElement.style.display = 'none';
    loadingElement.classList.add('loading-fallback');
  }
}

// Hide startup loading animation when Flutter is ready
window.addEventListener('flutter-first-frame', function () {
  const loadingElement = document.getElementById('flutter-loading');
  if (loadingElement) {
    loadingElement.classList.add('fade-out');
    setTimeout(function () {
      loadingElement.style.display = 'none';
    }, 300);
  }
});

// Fallback: Hide startup loading animation after a maximum time
setTimeout(function () {
  const loadingElement = document.getElementById('flutter-loading');
  if (loadingElement && loadingElement.style.display !== 'none') {
    loadingElement.classList.add('fade-out');
    setTimeout(function () {
      loadingElement.style.display = 'none';
    }, 500);
  }
}, 10000); // 10 seconds fallback