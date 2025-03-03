from typing import Dict
from pandas import DataFrame
from sqlalchemy.engine.base import Engine


def load(data_frames: Dict[str, DataFrame], database: Engine):
    """Load the dataframes into the sqlite database.

    Args:
        data_frames (Dict[str, DataFrame]): A dictionary with keys as the table names
        and values as the dataframes.
        database (Engine): The SQLAlchemy engine connected to the SQLite database.
    """
    for table_name, df in data_frames.items():
        # Cargar el DataFrame en la base de datos como una tabla
        df.to_sql(
            name=table_name,  # Nombre de la tabla
            con=database,     # Conexión a la base de datos
            if_exists='replace',  # Reemplazar la tabla si ya existe
            index=False       # No incluir el índice del DataFrame en la tabla
        )
        print(f"Tabla '{table_name}' cargada correctamente.")