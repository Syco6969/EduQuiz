/**
 * Chart and visualization functionality for EduQuiz application
 */

/**
 * Create a quiz completion chart
 * @param {string} canvasId - ID of the canvas element
 * @param {Array} labels - Array of labels (categories)
 * @param {Array} data - Array of data values
 */
function createQuizCompletionChart(canvasId, labels, data) {
    const ctx = document.getElementById(canvasId).getContext('2d');
    
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Quiz Completions',
                data: data,
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: 'Quiz Completions by Category',
                    font: {
                        size: 16
                    }
                },
                legend: {
                    display: false
                }
            }
        }
    });
}

/**
 * Create a score distribution chart
 * @param {string} canvasId - ID of the canvas element
 * @param {Array} data - Array of score values
 * @param {string} quizTitle - Quiz title
 */
function createScoreDistributionChart(canvasId, data, quizTitle) {
    const ctx = document.getElementById(canvasId).getContext('2d');
    
    // Calculate distribution
    const scoreRanges = ['0-20%', '21-40%', '41-60%', '61-80%', '81-100%'];
    const distribution = [0, 0, 0, 0, 0];
    
    data.forEach(score => {
        if (score <= 20) distribution[0]++;
        else if (score <= 40) distribution[1]++;
        else if (score <= 60) distribution[2]++;
        else if (score <= 80) distribution[3]++;
        else distribution[4]++;
    });
    
    new Chart(ctx, {
        type: 'pie',
        data: {
            labels: scoreRanges,
            datasets: [{
                data: distribution,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(255, 159, 64, 0.7)',
                    'rgba(255, 205, 86, 0.7)',
                    'rgba(75, 192, 192, 0.7)',
                    'rgba(54, 162, 235, 0.7)'
                ],
                borderColor: [
                    'rgb(255, 99, 132)',
                    'rgb(255, 159, 64)',
                    'rgb(255, 205, 86)',
                    'rgb(75, 192, 192)',
                    'rgb(54, 162, 235)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: quizTitle ? `Score Distribution: ${quizTitle}` : 'Score Distribution',
                    font: {
                        size: 16
                    }
                },
                legend: {
                    position: 'right'
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.raw || 0;
                            const total = distribution.reduce((acc, curr) => acc + curr, 0);
                            const percentage = Math.round((value / total) * 100);
                            return `${label}: ${value} (${percentage}%)`;
                        }
                    }
                }
            }
        }
    });
}

/**
 * Create a user activity chart
 * @param {string} canvasId - ID of the canvas element
 * @param {Array} dates - Array of date labels
 * @param {Array} activities - Array of activity counts
 */
function createUserActivityChart(canvasId, dates, activities) {
    const ctx = document.getElementById(canvasId).getContext('2d');
    
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: dates,
            datasets: [{
                label: 'User Activity',
                data: activities,
                fill: false,
                borderColor: 'rgb(75, 192, 192)',
                tension: 0.1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: 'User Activity Over Time',
                    font: {
                        size: 16
                    }
                }
            }
        }
    });
}

/**
 * Create a difficulty comparison chart
 * @param {string} canvasId - ID of the canvas element
 * @param {Object} difficultyData - Object with difficulty levels and average scores
 */
function createDifficultyComparisonChart(canvasId, difficultyData) {
    const ctx = document.getElementById(canvasId).getContext('2d');
    
    const difficulties = Object.keys(difficultyData);
    const averageScores = difficulties.map(key => difficultyData[key]);
    
    new Chart(ctx, {
        type: 'radar',
        data: {
            labels: difficulties,
            datasets: [{
                label: 'Average Score (%)',
                data: averageScores,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgb(75, 192, 192)',
                pointBackgroundColor: 'rgb(75, 192, 192)',
                pointBorderColor: '#fff',
                pointHoverBackgroundColor: '#fff',
                pointHoverBorderColor: 'rgb(75, 192, 192)'
            }]
        },
        options: {
            scales: {
                r: {
                    beginAtZero: true,
                    max: 100,
                    ticks: {
                        stepSize: 20
                    }
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: 'Average Scores by Difficulty',
                    font: {
                        size: 16
                    }
                }
            }
        }
    });
}

/**
 * Create a time vs. score chart
 * @param {string} canvasId - ID of the canvas element
 * @param {Array} timeData - Array of time values (in seconds)
 * @param {Array} scoreData - Array of score values
 */
function createTimeVsScoreChart(canvasId, timeData, scoreData) {
    const ctx = document.getElementById(canvasId).getContext('2d');
    
    // Prepare data points
    const dataPoints = timeData.map((time, index) => {
        return {
            x: time / 60, // Convert to minutes
            y: scoreData[index]
        };
    });
    
    new Chart(ctx, {
        type: 'scatter',
        data: {
            datasets: [{
                label: 'Time vs. Score',
                data: dataPoints,
                backgroundColor: 'rgba(153, 102, 255, 0.6)'
            }]
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Time Taken (minutes)'
                    }
                },
                y: {
                    beginAtZero: true,
                    max: 100,
                    title: {
                        display: true,
                        text: 'Score (%)'
                    }
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: 'Relationship Between Time Taken and Score',
                    font: {
                        size: 16
                    }
                }
            }
        }
    });
}

/**
 * Fetch chart data from the server via AJAX
 * @param {string} url - API endpoint URL
 * @param {Function} callback - Function to call with the data
 */
function fetchChartData(url, callback) {
    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            callback(data);
        })
        .catch(error => {
            console.error('Error fetching chart data:', error);
            showErrorMessage('Failed to load chart data: ' + error.message);
        });
}

/**
 * Initialize all dashboard charts
 */
function initializeDashboardCharts() {
    // Quiz completions by category
    fetchChartData('/api/stats/quiz-completions', data => {
        createQuizCompletionChart('quizCompletionChart', data.labels, data.values);
    });
    
    // User activity
    fetchChartData('/api/stats/user-activity', data => {
        createUserActivityChart('userActivityChart', data.dates, data.activities);
    });
    
    // Average scores by difficulty
    fetchChartData('/api/stats/difficulty-scores', data => {
        createDifficultyComparisonChart('difficultyChart', data);
    });
}