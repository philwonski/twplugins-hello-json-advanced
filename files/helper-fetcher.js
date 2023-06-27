const fetchJson = (url) => {
    return new Promise((resolve, reject) => {
        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(jsonData => resolve(JSON.stringify(jsonData)))
            .catch(error => reject(error.message));
    });
};

module.exports = fetchJson;
