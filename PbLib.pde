/**
  Processing部で共用するライブラリclass
  2017/03/26  tatsu.
  
  > PbPoint       XY点のクラス。XYベクトル計算も可。点の色透明度も。
  > PbRect        2次元四角形のクラス。点との内外判定も。
  > PbLine        2次元直線のクラス。
  > PbCircle      2次元円のクラス。3点円など。

  > PbColor       色と透明度
  > PbGrid        格子状に並んだオブジェクト郡
  > PbImageGrid   画像を格子状のオブジェクトに分解したもの
  > PbTimeFrame   時間枠。

  > PbScene       経過時間により再生シーンをシーン毎に変更するためのクラス。
  > PbSubScene    シーンの中を細分化して描画するためのクラス。
  > PbScenes      複数のシーンを管理するためのクラス。
*/

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
  {
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
    return getDist( 0.0, 0.0 );
  }

  /**
    指定点との距離を測る
  */
  float  getDist( PbPoint _pos )
  {
    return getDist( _pos.getX(), _pos.getY() );
  }

  float  getDist( float _x, float _y )
  {
    return dist( _x, _y, this.getX(), this.getY() );
  }


  /**
		位置ベクトルにベクトルを加算する。
  */
  PbPoint add( PbPoint _vec )
  {
    return add( _vec.getX(), _vec.getY() );
  }

  PbPoint add( float _x, float _y )
  {
    addX( _x );
    addY( _y );

    return this;
  }

  PbPoint addX( float _x )
  {
    _X += _x;

    return this;
  }

  PbPoint addY( float _y )
  {
    _Y += _y;

    return this;
  }

  /**
    位置ベクトルにベクトルを減算する。
  */
  PbPoint sub( PbPoint _vec )
  {
    return sub( _vec.getX(), _vec.getY() );
  }

  PbPoint sub( float _x, float _y )
  {
    _X -= _x;
    _Y -= _y;

    return this;
  }

  /**
    位置ベクトルを乗算する。
  */
  PbPoint mul( float _m )
  {
    _X *= _m;
    _Y *= _m;

    return this;
  }

  /**
    位置ベクトルを除算する。
  */
  PbPoint div( float _m )
  {
    _X /= _m;
    _Y /= _m;

    return this;
  }

  /**
    単位ベクトルを得る。
  */
  PbPoint getUnitVector()
  {
    PbPoint  vec = getVector( 0.0, 0.0 );
    float    len = getLength();

    return   vec.div( len );
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
  */
  PbMovePoint()
  {
    // XYを0クリア、移動量は（1,1）で初期化する
    super();
    _Step = new PbPoint( 1, 1 );
  }

  // is
  
  // get/set
    void setRandom(
    float  _pos_x,
    float  _pos_y,
    float  _vec_s,
    float  _vec_e
  )
  {
    this.setRandom( _pos_x, _pos_y );
    _Step.setRandom( _vec_s, _vec_e );
  }

  // update

  /**
    座標を移動する。
  */
  void MoveStep()
  {
    this.add( _Step );
  }

  /**
    四角の内側で座標を移動する。
  */
  void MoveStepInRect( PbRect _rect )
  {
    this.add( _Step );

    if( _rect.isOut( this ) )
    {
      PbPoint  over_xy = _rect.getOverAmount( this );

      // はみ出した量の逆符号にして加算する。移動量も符号を反転する。
      if( over_xy.getX() != 0.0 )
      {
        this.addX( -over_xy.getX() );
        _Step.setX( -_Step.getX() );
      }

      if( over_xy.getY() != 0.0 )
      {
        this.addY( -over_xy.getY() );
        _Step.setY( -_Step.getY() );
      }
    }
  }

  /**
    四角の内側で座標を移動する。
  */
  void MoveStepOutRect( PbRect _rect )
  {
    this.add( _Step );

    if( _rect.isIn( this ) )
    {
      PbPoint  over_xy = _rect.getBiteAmount( this );

      // はみ出した量の逆符号にして加算する。移動量も符号を反転する。
      if( over_xy.getX() != 0.0 )
      {
        this.addX( -over_xy.getX() );
        _Step.setX( -_Step.getX() );
      }

      if( over_xy.getY() != 0.0 )
      {
        this.addY( -over_xy.getY() );
        _Step.setY( -_Step.getY() );
      }
    }
  }

}

/**
  四角形クラス
*/
class PbRect
{
  PbPoint  _Sp;  // 小さい座標
  PbPoint  _Ep;  // 大きい座標

  // getter/setter
  PbPoint  getSp() { return new PbPoint(_Sp);  }
  PbPoint  getEp() { return new PbPoint(_Ep);  }
  
  /**
    constractor
  */
  PbRect( PbRect _rect )
  {
    setRect(
      _rect.getSp().getX(), _rect.getSp().getY(),
      _rect.getEp().getX(), _rect.getEp().getY()
    );    
  }

  PbRect( PbPoint _sp, PbPoint _ep )
  {
    setRect( _sp.getX(), _sp.getY(), _ep.getX(), _ep.getY() );    
  }

  PbRect( float _spx, float _spy, float _epx, float _epy )
  {
    setRect( _spx, _spy, _epx, _epy );    
  }
  
  PbRect( PbPoint _pos )
  {
    setRect( _pos.getX(), _pos.getY(), _pos.getX(), _pos.getY() );    
  }

  // -is-

  /**
    四角の外に出ているか調べる。
    境界は出ていないと判断する。
  */
  boolean  isOut(
    PbPoint  _pos  // I:点
  )
  {
    float  x = _pos.getX();

    if( _Sp.getX() > x ||
        _Ep.getX() < x )
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
    四角の内側の入っているかを調べる。
    境界は入っていると判断する。
  */
  boolean  isIn(
    PbPoint  _pos  // I:点
  )
  {
    boolean b = isOut( _pos );
    
    return !b;
  }
  
  // get/set
  void setRect( float _spx, float _spy, float _epx, float _epy )
  {
    float  sp_x = ( _spx <  _epx ) ? _spx: _epx;
    float  sp_y = ( _spy <  _epy ) ? _spy: _epy;
    float  ep_x = ( _spx >= _epx ) ? _spx: _epx;
    float  ep_y = ( _spy >= _epy ) ? _spy: _epy;
    
    // 始点-終点 で四角形を表す。
    _Sp = new PbPoint( sp_x, sp_y );
    _Ep = new PbPoint( ep_x, ep_y );
  }

  float  getW()
  {
    return ( _Ep.getX() - _Sp.getX() );
  }
  
  float  getH()
  {
    return ( _Ep.getY() - _Sp.getY() );
  }
  
  /**
    中心点を取得する。
  */
  PbPoint  getCenter()
  {
    float  x = (_Sp.getX() + _Ep.getX() ) / 2.0;
    float  y = (_Sp.getY() + _Ep.getY() ) / 2.0;

    return new PbPoint( x, y );
  }
    
  /**
    外にどれだけ出ているかの量(X,Y)を計算する。
  */
  PbPoint  getOverAmount( PbPoint _pos )
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

  /**
    内にどれだけ食い込んでいるか量(X,Y)を計算する。
  */
  PbPoint  getBiteAmount( PbPoint _pos )
  {
    // X方向の量を計算する。
    float  pos_x = _pos.getX();
    float  bite_x = 0.0;
    
    if( ( _Sp.getX() < pos_x ) && ( pos_x < _Ep.getX() ) )
    {
      float bite_sx = pos_x - _Sp.getX();
      float bite_ex = pos_x - _Ep.getX();

      // 食い込みが浅い方を選択する。
      bite_x = (abs( bite_sx ) < abs( bite_ex )) ? bite_sx: bite_ex;
    }

    // Y方向の量を計算する。
    float  pos_y = _pos.getY();
    float  bite_y = 0.0;
    
    if( ( _Sp.getY() < pos_y ) && ( pos_y < _Ep.getY() ) )
    {
      float bite_sy = pos_y - _Sp.getY();
      float bite_ey = pos_y - _Ep.getY();

      // 食い込みが浅い方を選択する。
      bite_y = (abs( bite_sy ) < abs( bite_ey )) ? bite_sy: bite_ey;
    }

    // ベクトルにして返す。
    PbPoint  ret;
    if( abs( bite_x ) < abs( bite_y ) ) {
      ret = new PbPoint( bite_x, 0.0 );
    }
    else if( abs( bite_x ) > abs( bite_y ) ) {
      ret = new PbPoint( 0.0, bite_y );
    }
    else {
      ret = new PbPoint( bite_x, bite_y );
    }
    
    return ret;
  }

  // update
  
  /**
    四角形を大きくする。
  */
  void  inflate( float _x, float _y )
  {
    _Sp.setX( _Sp.getX() - _x );
    _Sp.setY( _Sp.getY() - _y );
    _Ep.setX( _Ep.getX() + _x );
    _Ep.setY( _Ep.getY() + _y );
  }
}

/**
  直線のクラス
*/
class PbLine
{
  PbPoint  _Sp;  // 始点
  PbPoint  _Ep;  // 終点

  // getter/setter
  PbPoint  getSp()              { return new PbPoint(_Sp); }
  void     setSp( PbPoint _s )  { _Sp = _s;   }

  PbPoint  getEp()              { return new PbPoint(_Ep); }
  void     setEp( PbPoint _e )  { _Ep = _e;   }
  
  PbPoint  getVecSE()
  {
    PbPoint  s = new PbPoint( _Sp );
    PbPoint  e = new PbPoint( _Ep );

    return e.sub( s );
  }
  
  PbPoint  getVecES()
  {
    return getVecSE().mul( -1.0 );
  }
  
  // constractor
  
  PbLine( PbPoint _s, PbPoint  _e )
  {
    _Sp = new PbPoint( _s );
    _Ep = new PbPoint( _e );
  }

  // update
  
  /**
    直線を延長する。
  */
  void  extend( float  _len )
  {
    // 始終点間の単位ベクトルに長さを掛けて加算する。
    _Ep.add( getVecSE().getUnitVector().mul( _len ) );
    _Sp.add( getVecES().getUnitVector().mul( _len ) );
  }
}

/**
  円のクラス。
*/
class PbCircle
{
  PbPoint  _Cp;   // 中心点
  float    _Rad;  // 半径

  // constractor
  
  // 3点円弧
  PbCircle( PbPoint _p1, PbPoint _p2, PbPoint _p3 )
  {
    // 2直線の交点として求めたほうが早いかも。
    // http://examist.jp/mathematics/figure-circle/circle/
    
    ;
  }
}

/**
  色のクラス。
*/
class PbColor
{
  color  _Color;
  float  _Alpha;

  // getter/setter

  color  getColor()           { return color(_Color); }
  void   setColor( color _c ) { _Color = color( _c ); }

  float  getAlpha()           { return color(_Alpha); }
  void   setAlpha( float _a ) { _Alpha = _a; }

  void setRandomColor()
  {
    setColor( color( random(255), random(255), random(255) ) );
  }

  void setRandomAlpha()
  {
    setAlpha( random(255) );
  }
}

/**
  格子状のデータ
*/
class PbGrid
{
  int        _XNum;
  int        _YNum;
  PbRect[][] _GridRect;
  
  // getter/setter
  int  getXNum() { return _XNum;  }
  int  getYNum() { return _YNum;  }

  /**
    コンストラクタ
  */
  PbGrid( int _w, int _h, int _x_num, int _y_num )
  {
    _XNum = _x_num;
    _YNum = _y_num;
    
    // 要素数分確保する。
    _GridRect = new PbRect[_x_num][_y_num];

    int  w_step = _w / _x_num;
    int  h_step = _h / _y_num;
     
    // オブジェクトを配置する。
    for( int x = 0; x < _x_num; ++x ) {
      for( int y = 0; y < _y_num; ++y ) {
         
        int sx = w_step * x;
        int ex = w_step * (x+1) -1;
        int sy = h_step * y;
        int ey = h_step * (y+1) -1;
         
        _GridRect[x][y] = new PbRect( sx, sy, ex, ey );
      }
    }
  }

  /**
    グリッドを１つ取得する
  */
  PbRect getGrid( int _x, int _y )
  {
    return new PbRect( _GridRect[_x][_y] );
  }
}

/**
  画像を格子状のオブジェクトに分解したもの。
*/
class PbImageGrid extends PbGrid
{
  PImage  _Image;

  /**
    コンストラクタ
  */
  PbImageGrid( PImage _img, int _w, int _h, int _x, int _y )
  {
    super( _w, _h, _x, _y );
    
    // 画像をコピーして覚える。
    _Image = _img.get( 0, 0, _img.width, _img.height );
  }

  /**
    イメージを取得する。
  */
  PImage  getImage( PbRect  _rect )
  {
    int  x = (int)_rect.getSp().getX();
    int  y = (int)_rect.getSp().getY();
    int  w = (int)_rect.getW();
    int  h = (int)_rect.getH();
    
    PImage img = _Image.get( x, y, w, h );
    
    return img;
  }
}

/**
  時間枠
*/
class PbTimeFrame
{
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

  int  getStartTime() { return _StartTime; }
  int  getEndTime()   { return _EndTime;   }

  /**
    コンストラクタ
  */
  PbTimeFrame()
  {
    _StartTime = _EndTime = 0;
  }

  /**
    コンストラクタ
  */
  PbTimeFrame( int _s, int _e )
  {
    _StartTime = _s;
    _EndTime   = _e;
  }

  /**
    シーンの再生時間であれば true を返す。
  */
  public boolean isPlayTime( int _time )
  {
    return ( (_StartTime <= _time) && (_time < _EndTime) );
  }

  /**
    シーンの〜％経過したかを返す。
  */
  public float elapsedTimeRate( int _time )
  {
    float all_time  = _EndTime - _StartTime;
    float rest_time = _EndTime - _time;

//  println( all_time + ":" + now_time );

    float rate = 1.0 - rest_time / all_time;

    return rate;
  }

  /**
    再生時間長さ
  */
  int  getLength()
  {
    return _EndTime - _StartTime;
  }
}

/**
  シーン抽象クラス
*/
abstract class PbScene
{
  PbTimeFrame  _Tf;
  int          _Current;
  boolean      _Finished;

  // getter/setter
  int      getLength()  { return _Tf.getLength();  }
  
  int      getCurrnet()         { return _Current; }
  void     setCurrent( int _c ) { _Current = _c;   }

  boolean  getFinished()             { return _Finished; }
  void     setFinished( boolean _b ) { _Finished = _b;   }
  
  /**
    コンストラクタ
  */
  PbScene( int _s, int _e )
  {
    _Tf = new PbTimeFrame(); 
    
    _Tf.setTime( _s, _e );

    // 初期化処理
    init();
    
    // 最後の処理
    setFinished( false );
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
  public boolean isPlayTime( int _time )
  {
    return _Tf.isPlayTime( _time );
  }

  /**
    シーンでの再生が過ぎていれば true を返す。
  */
  public boolean IsPlayOver( int _time )
  {
    return ( _Tf.getEndTime() < _time );
  }

  /**
    シーンの〜％経過したかを返す。
  */
  public float elapsedTimeRate()
  {
    return _Tf.elapsedTimeRate( _Current );
  }

  public float elapsedTimeRate( int _time )
  {
    return _Tf.elapsedTimeRate( _time );
  }
}

/**
  サブシーン抽象クラス
  （シーンを等間隔で細分化して描画する際に使用するシーンクラス）
*/
abstract class PbSubScene extends PbScene
{
  ArrayList<PbTimeFrame> _TimeFrames;
  int                    _TimeStep;
  
  /**
    コンストラクタ
  */
  PbSubScene( int _s, int _e, int _div )
  {
    super( _s, _e ); //<>//

    _TimeStep = (_e - _s) / _div;
    
    // 分割数分の時間間隔オブジェクトを作る。
    _TimeFrames = new ArrayList<PbTimeFrame>();
    
    for( int i = 0; i < _div; ++i )
    {
      int  s = _TimeStep * i;
      int  e = (_TimeStep * (i+1))-1;
      
      _TimeFrames.add( new PbTimeFrame( s, e ) ); //<>//
    }
  }
  
  /**
    描画する。
  */
  final void draw()
  { //<>//
    // 今の進捗率から、サブ描画の進捗率を得る。
    
    for( int i = 0; i < _TimeFrames.size(); ++i ) //<>//
    {
      // 経過率を計算する。
      float  rate = _TimeFrames.get(i).elapsedTimeRate( getCurrnet() );

      // 経過に満たないもの、経過を追えたものを除去して計算する。
      if( 0.0 <= rate && rate <= 1.0 )
      {
//      println( "%d:%lf¥n", i, rate );
        
        drawSub( i, rate );
      }
    }
  }
  
  /**
    細分化して描画するときのメンバ
  */
  abstract public void drawSub( int _i, float _rate );
}

/**
  シーンを管理するオブジェクト
*/
class PbScenes extends ArrayList<PbScene>
{
  boolean  _LoopPlay;
  int      _LoopAdjust;

  // getter/setter
  void  setLoopAdjust( int _a )  { _LoopAdjust = _a;  }

  /**
    コンストラクタ
  */
  PbScenes()
  {
    _LoopPlay   = true;
    _LoopAdjust = 0;
  }
  
  /**
    再生するシーンを描画する。
  */
  void drawScene( int _millis )
  {
    int play_count = 0; //<>//
  
    int current = _millis;
  
    // 再生時間に達していたら、そのシーンを再生する。
    for( int i = 0; i < size(); ++i )
    {
      if( get(i).isPlayTime( current - _LoopAdjust ) )
      {
        get(i).setCurrent( current - _LoopAdjust );
        get(i).draw();
      
        // 再生シーン数を数える。
        ++play_count;
      }
      else if( get(i).isPlayOver( current - _LoopAdjust ) )
      {
        get(i).
        
        get(i).setCurrent( );
        get(i).finish();
      }
    }
    
    // １シーンもを再生しなかったら、開始終了時間を更新して、また初めから再生する。
    if( play_count == 0 && _LoopPlay )
    {
      _LoopAdjust = current;
    }
  }
}