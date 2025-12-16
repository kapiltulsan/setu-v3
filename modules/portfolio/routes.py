from flask import render_template, request, jsonify, current_app
from . import portfolio_bp
from .logic import process_zerodha_file, process_smallcase_file, get_portfolio_summary, get_pnl_summary

@portfolio_bp.route('/portfolio')
def portfolio_dashboard():
    """Render the main Portfolio & P&L page."""
    portfolio_data = get_portfolio_summary()
    pnl_data = get_pnl_summary()
    return render_template('portfolio.html', portfolio=portfolio_data, pnl=pnl_data)

@portfolio_bp.route('/api/portfolio/summary')
def api_portfolio_summary():
    """Return Portfolio Summary as JSON for Dashboard."""
    try:
        portfolio_rows = get_portfolio_summary()
        
        # Calculate Aggregates
        total_invested = sum(row['invested_value'] for row in portfolio_rows)
        # Note: current_value might not be populated yet if no external data, default to invested if 0?
        # For now, let's assume it might be 0.
        current_value = sum(row['current_value'] for row in portfolio_rows)
        if current_value == 0:
             current_value = total_invested # Fallback if no live data yet
             
        pnl_absolute = current_value - total_invested
        pnl_percent = (pnl_absolute / total_invested * 100) if total_invested > 0 else 0
        
        return jsonify({
            "summary": {
                "total_invested": total_invested,
                "current_value": current_value,
                "pnl_absolute": pnl_absolute,
                "pnl_percent": round(pnl_percent, 2)
            },
            "holdings": portfolio_rows # RealDictCursor returns list of dicts
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@portfolio_bp.route('/api/upload/zerodha', methods=['POST'])
def upload_zerodha():
    """Handle Zerodha Tradebook upload."""
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
        
    try:
        success, message = process_zerodha_file(file)
        if success:
            return jsonify({'message': message}), 200
        else:
            return jsonify({'error': message}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@portfolio_bp.route('/api/upload/smallcase', methods=['POST'])
def upload_smallcase():
    """Handle Smallcase Orders upload."""
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
        
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
        
    try:
        success, message = process_smallcase_file(file)
        if success:
            return jsonify({'message': message}), 200
        else:
            return jsonify({'error': message}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500
