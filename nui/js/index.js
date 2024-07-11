window.addEventListener('DOMContentLoaded', () => {
    console.log('DOM content for sketchpad fully loaded');

    // Fetch Control Inputs & Handle Changes
        // For eraser, change color to completely white.
        // For brush, change color back to set color.

    let color, size;

    const sketchContainer = document.getElementById('sketchContainer');
    const viewContainer = document.getElementById('viewContainer');

    const colorInput = document.getElementById('color');
    const sizeInput = document.getElementById('size');
    
    const brushBtn = document.getElementById('brush');
    const eraserBtn = document.getElementById('eraser');
    
    const sendBtn = document.getElementById('send');
    const sendModal = document.getElementById('sendModal');
    const sendClose = document.getElementById('sendClose');
    
    const sendPlayerIdBtn = document.getElementById('sendPlayerId');
    const playerIdInput = document.getElementById('playerIdInput');

    const errorModal = document.getElementById('errorModal');
    const errorMessage = document.getElementById('errorMessage');
    const closeErrorModal = document.getElementById('errorClose');
    
    colorInput.addEventListener('change', (e) => {
        brushBtn.className = 'toggled';
        eraserBtn.className = '';

        color = e.target.value;
    });
    
    sizeInput.addEventListener('change', (e) => {
        size = e.target.value;
    });
    
    brushBtn.addEventListener('mouseup', () => {
        brushBtn.className = 'toggled';
        eraserBtn.className = '';
    
        color = colorInput.value;
    });
    
    eraserBtn.addEventListener('mouseup', () => {
        eraserBtn.className = 'toggled';
        brushBtn.className = '';
    
        color = '#fff';
    });
    
    function showErrorModal(message) {
        errorMessage.textContent = message;
        errorModal.style.display = 'block';
    }

    closeErrorModal.addEventListener('mouseup', () => {
        errorModal.style.display = 'none';
        errorMessage.textContent = '';
    });

    // Sketchpad Functionality
    const sketchpad = document.getElementById('sketchpad');
    const ctx = sketchpad.getContext('2d');
    
    function resizeCanvas() {
        const container = sketchpad.parentElement;

        console.log("Container clientWidth:", container.clientWidth);
        console.log("Container clientHeight:", container.clientHeight);

        if (container.clientWidth === 0 || container.clientHeight === 0) {
            console.error("Container dimensions are zero. Make sure the container has dimensions.");
            return;
        }

        const containerStyles = window.getComputedStyle(container);
        const containerWidth = container.clientWidth - parseFloat(containerStyles.paddingLeft) - parseFloat(containerStyles.paddingRight);
        const containerHeight = container.clientHeight - parseFloat(containerStyles.paddingTop) - parseFloat(containerStyles.paddingBottom);

        console.log("Calculated containerWidth:", containerWidth);
        console.log("Calculated containerHeight:", containerHeight);

        sketchpad.width = containerWidth;
        sketchpad.height = containerHeight;

        console.log('Canvas resized:', sketchpad.width, sketchpad.height);
    }

    // Initial resize
    resizeCanvas();

    window.addEventListener('resize', resizeCanvas);

    let lastEvent;
    let mouseDown = false;

    console.log(sketchpad.offsetHeight, sketchpad.offsetWidth);

    sketchpad.addEventListener('mousedown', (e) => {
        lastEvent = e;
        mouseDown = true;
    });
    
    sketchpad.addEventListener('mousemove', (e) => {
        if (mouseDown) {
            ctx.beginPath();
            ctx.moveTo(lastEvent.offsetX, lastEvent.offsetY);
            ctx.lineTo(e.offsetX, e.offsetY);
    
            ctx.lineWidth = size;
            ctx.strokeStyle = color;
            ctx.lineCap = 'round';
            ctx.fillStyle = '#fff';
            
            ctx.stroke();
            lastEvent = e;
        }
    });
    
    window.addEventListener('mouseup', () => {
        mouseDown = false;
    });
    
    const clearBtn = document.getElementById('clear');
    clearBtn.addEventListener('mouseup', (e) => {
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(0, 0, sketchpad.clientWidth, sketchpad.clientHeight);
    });
    
    // Send Functionality
    sendBtn.addEventListener('click', () => {
        sendModal.style.display = 'block';
    });

    sendClose.onclick = function() {
        sendModal.style.display = 'none';
        playerIdInput.textContent = '';
    }

    sendPlayerIdBtn.addEventListener('click', () => {
        const playerId = parseInt(playerIdInput.value);
        if (!isNaN(playerId)) {
            const dataURL = sketchpad.toDataURL('image/png', 1.0).split(';base64,')[1];
            fetch(`https://${GetParentResourceName()}/saveSketch`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ image: dataURL, requestId: playerId }),
            })
            .then(response => response.json())
            .then(data => {
                console.log('Success:', data);

                sendModal.style.display = 'none';
                
                sketchContainer.classList.add('hidden');
                document.body.style.background = 'transparent';

                fetch(`https://${GetParentResourceName()}/closeSketchpad`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                    },
                    body: JSON.stringify({})
                });
            })
            .catch((error) => {
                console.error('Error:', error);
                showErrorModal('Server ID was incorrect or there is an internal server error.');
            });
        } else {
            showErrorModal('Please enter a valid Player ID.');
        }
    });

    // NUI Handler
    window.addEventListener('message', (event) => {
        console.log("Message received: ", event.data);

        if (event.data.type === 'openSketchpad') {
            colorInput.value = '#000000';
            sizeInput.value = '3';
            
            color = colorInput.value;
            size = sizeInput.value;

            playerIdInput.value = '';

            ctx.fillStyle = '#FFFFFF';
            ctx.fillRect(0, 0, sketchpad.clientWidth, sketchpad.clientHeight);

            viewContainer.classList.add('hidden');

            sketchContainer.classList.remove('hidden');
            document.body.style.background = 'rgba(0, 0, 0, 0.5)';
        }
    });

    window.addEventListener('message', (event) => {
        console.log("Message received: ", event.data);

        if (event.data.type === 'closeSketchpad') {
            sketchContainer.classList.add('hidden');
            document.body.style.background = 'transparent';

            sendModal.style.display = 'none';
            playerIdInput.textContent = '';

            errorModal.style.display = 'none';
            errorMessage.textContent = '';

            fetch(`https://${GetParentResourceName()}/closeSketchpad`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                }
            });
        }
    });
    
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            sketchContainer.classList.add('hidden');
            document.body.style.background = 'transparent';

            sendModal.style.display = 'none';
            playerIdInput.textContent = '';

            errorModal.style.display = 'none';
            errorMessage.textContent = '';

            fetch(`https://${GetParentResourceName()}/closeSketchpad`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({})
            });
        }
    });

    // Sketchpad View
    const image = document.getElementById('viewImage');
    const imageInfo = document.getElementById('imageInfo');

    // NUI Handler
    window.addEventListener('message', (event) => {
        console.log("Message received: ", event.data);

        if (event.data.type === 'openSketchpad_View') {
            image.src = event.data.url;
            imageInfo.textContent = `${event.data.playerData.senderName} (Server #${event.data.playerData.senderId})`

            viewContainer.classList.remove('hidden');
            document.body.style.background = 'rgba(0, 0, 0, 0.5)';

            sketchContainer.classList.add('hidden');
        }
    });

    window.addEventListener('message', (event) => {
        console.log("Message received: ", event.data);
        if (event.data.type === 'closeSketchpad_View') {
            viewContainer.classList.add('hidden');
            document.body.style.background = 'transparent';

            fetch(`https://${GetParentResourceName()}/closeSketchpad_View`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                }
            });
        }
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            viewContainer.classList.add('hidden');
            document.body.style.background = 'transparent';

            fetch(`https://${GetParentResourceName()}/closeSketchpad_View`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({})
            });
        }
    });
});