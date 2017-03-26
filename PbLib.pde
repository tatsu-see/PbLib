
/**
  XY点クラス
*/
class PbPoint {

  float  _X;
  float  _Y;

  // getter/setter
  float getX() { return _X; }
  float getY() { return _Y; }

  void setX( float _x ) { _X = _x; }
  void setY( float _y ) { _Y = _y; }
  void setXY( float _x, float _y ) { _X = _x; _Y = _y; }

  void setRandom( float _x, float _y )
  {
    _X = random( _x );
    _Y = random( _y );
  }

  void setRandom( float _sx, float _sy, float _ex, float _ey  )
  { //<>//
    _X = random( _sx, _ex );
    _Y = random( _sy, _ey );
  }

  /**
    コンストラクタ
    0クリアする
  */
  PbPoint()
  {
    _X = _Y = 0;
  }

  /**
    コンストラクタ
    0〜 指定範囲内で、座標を初期化する。
  */
  PbPoint( float _w, float _h )
  {
    _X = _w;
    _Y = _h;
  }

  /**
    コピーコンストラクタ
  */
  PbPoint( PbPoint _pos )
  {
    _X = _pos.getX();
    _Y = _pos.getY();
  }

  /**
    0ベクトルかチェックする
  */
  boolean  IsZero()
  {
    return ( (_X == 0.0) && (_Y == 0.0) );
  }

  /**
    ベクトルの長さを得る
  */
  float  getLength()
  {
    return Dist( 0.0, 0.0 );
  }

  /**
    指定点との距離を測る
  */
  float  Dist( PbPoint _pos )
  {
    return Dist( _pos.getX(), _pos.getY() );
  }

  float  Dist( float _x, float _y )
  {
    return dist( _x, _y, this.getX(), this.getY() );
  }


/**
		位置ベクトルにベクトルを加算する。
  */
  PbPoint Add( PbPoint _vec )
  {
    return Add( _vec.getX(), _vec.getY() );
  }

  PbPoint Add( float _x, float _y )
  {
    _X += _x;
    _Y += _y;

    return this;
  }

  /**
    位置ベクトルにベクトルを減算する。
  */
  PbPoint Sub( PbPoint _vec )
  {
    return Sub( _vec.getX(), _vec.getY() );
  }

  PbPoint Sub( float _x, float _y )
  {
    _X -= _x;
    _Y -= _y;

    return this;
  }

  /**
    位置ベクトルを乗算する。
  */
  PbPoint Mul( float _m )
  {
    _X *= _m;
    _Y *= _m;

    return this;
  }

  /**
    位置ベクトルを除算する。
  */
  PbPoint Div( float _m )
  {
    _X /= _m;
    _Y /= _m;

    return this;
  }

  /**
    単位ベクトルを得る。
  */
  PbPoint getUnitvector()
  {
    PbPoint  vec = getVector( 0.0, 0.0 );
    float    len = getLength();

    return   vec.Div( len );
  }

  /**
    自分に向うベクトルを取得する。
  */
  PbPoint  getVector( PbPoint _pos )
  {
    return getVector( _pos.getX(), _pos.getY() );
  }

  PbPoint  getVector( float _x, float _y )
  {
    float  x = this.getX() - _x;
    float  y = this.getY() - _y;

    return new PbPoint( x, y );
  }
}

/**
  移動点クラス
*/
class PbMovePoint extends PbPoint
{
  PbPoint _Step;  // 移動量

  // getter/setter
  PbPoint getStep()             { return new PbPoint( _Step ); }
  void    setStep( PbPoint _s ) { _Step = new PbPoint( _s ); }

  /**
    コンストラクタ
    XYを0クリア、移動量は（1,0）で初期化する
  */
  PbMovePoint()
  {
    super();
    _Step = new PbPoint( 1, 1 );
  }

  /**
    四角の内側で座標を移動する。
  */
  void MoveStepInRect( PbRect _rect )
  {
    this.Add( _Step );

    if( _rect.IsOut( this ) )
    {
      PbPoint  over_xy = _rect.getOverFloat( this );

      

    }
  }

  /**
    座標を移動する。
  */
  void MoveStep()
  {
    this.Add( _Step );
  }
}

/**
  四角形クラス
*/
class PbRect
{
  PbPoint  _Sp;
  PbPoint  _Ep;
  
  PbRect( PbPoint _sp, PbPoint _ep )
  {
    float  sp_x = ( _sp.getX() < _ep.getX() ) ? _sp.getX(): _ep.getX();
    float  sp_y = ( _sp.getY() < _ep.getY() ) ? _sp.getY(): _ep.getY();
    float  ep_x = ( _sp.getX() >= _ep.getX() ) ? _sp.getX(): _ep.getX();
    float  ep_y = ( _sp.getY() >= _ep.getY() ) ? _sp.getY(): _ep.getY();
    
    // 始点-終点 で四角形を表す。
    _Sp = new PbPoint( sp_x, sp_y );
    _Ep = new PbPoint( ep_x, ep_y );
  }
  
  /**
    四角の外に出ているか調べる。
    境界は出ていないと判断する。
  */
  boolean  IsOut(
    PbPoint  _pos
  )
  {
    float  x = _pos.getX();

    if( _Sp.getX() > x ||
        _Ep.getX() < x ) {
    {
      return true;
    }

    float  y = _pos.getY();
    
    if( _Sp.getY() > y ||
        _Ep.getY() < y )
    {
      return true;
    }
    
    return false;
  }
  
  /**
    外にどれだけ出ているかの量(X,Y)を計算する。
  */
  PbPoint  getOverFloat( PbPoint _pos )
  {
    // X方向の量を計算する。
    float  pos_x = _pos.getX();
    float  over_x = 0.0;
    
    if( pos_x < _Sp.getX() ) {
      over_x = pos_x - _Sp.getX();
    }
    else if( pos_x > _Ep.getX() ) {
      over_x = pos_x - _Ep.getX();
    }

    // Y方向の量を計算する。
    float  pos_y = _pos.getY();
    float  over_y = 0.0;
    
    if( pos_y < _Sp.getX() ) {
      over_y = pos_y - _Sp.getY();
    }
    else if( pos_y > _Ep.getX() ) {
      over_y = pos_y - _Ep.getY();
    }

    // ベクトルにして返す。
    return new PbPoint( over_x, over_y );
  }  
}

/**
  シーン抽象クラス
*/
abstract class PbScene {

  /**
    シーンの開始終了時間を設定する。millis() の時間で設定する。
    再生は _Start ≦ time ＜ _EndTime が担当時間とする。
  */
  int  _StartTime;  // シーンの開始時間。プログラム開始からの時間 [msec]
  int  _EndTime;    // シーンの終了時間。プログラム開始からの時間 [msec]

  // setter/getter
  void setTime( int _s, int _e )
  {
    _StartTime = _s;
    _EndTime = _e;
  }

  /**
    コンストラクタ
  */
  PbScene( int _s, int _e )
  {
    setTime( _s, _e );

    // 初期化処理
    init();
  }

  /**
    派生クラスでシーンの描画を記述する。
  */
  abstract public void draw();

  /**
    派生クラスでシーンの初期化処理を記述する。
  */
  abstract public void init();

  /**
    シーンの再生時間であれば true を返す。
  */
  public boolean isPlaytime( int _time )
  {
    return ( (_StartTime <= _time) && (_time < _EndTime) );
  }

  /**
    シーンの〜％経過したかを返す。
  */
  public float elapsedTimeRate( int _time )
  {
    float all_time = _EndTime - _StartTime;
    float now_time = _EndTime - _time;

//  println( all_time + ":" + now_time );

    float rate = 1.0 - now_time / all_time;

    return rate;
  }
}