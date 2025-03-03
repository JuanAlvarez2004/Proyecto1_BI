from typing import Dict

import requests
from pandas import DataFrame, read_csv, read_json, to_datetime


def get_public_holidays(public_holidays_url: str, year: str) -> DataFrame:
    """Get the public holidays for the given year for Brazil.

    Args:
        public_holidays_url (str): url to the public holidays.
        year (str): The year to get the public holidays for.

    Raises:
        SystemExit: If the request fails.

    Returns:
        DataFrame: A dataframe with the public holidays.
    """
    # Construir la URL completa
    url = f"{public_holidays_url}/{year}/BR"
    
    try:
        # Realizar la petición HTTP
        response = requests.get(url)
        
        # Verificar si la petición fue exitosa
        response.raise_for_status()
        
        # Convertir los datos JSON a un DataFrame
        holidays_df = DataFrame(response.json())
        
        # Eliminar las columnas "types" y "counties"
        if 'types' in holidays_df.columns:
            holidays_df = holidays_df.drop(columns=['types'])
        if 'counties' in holidays_df.columns:
            holidays_df = holidays_df.drop(columns=['counties'])
        
        # Convertir la columna "date" a datetime
        holidays_df['date'] = to_datetime(holidays_df['date'])
        
        return holidays_df
        
    except requests.exceptions.RequestException as e:
        # Si hay un error en la petición, terminar el programa
        raise SystemExit(f"Error al obtener datos de días festivos: {e}")


def extract(
    csv_folder: str, csv_table_mapping: Dict[str, str], public_holidays_url: str
) -> Dict[str, DataFrame]:
    """Extract the data from the csv files and load them into the dataframes.
    Args:
        csv_folder (str): The path to the csv's folder.
        csv_table_mapping (Dict[str, str]): The mapping of the csv file names to the
        table names.
        public_holidays_url (str): The url to the public holidays.
    Returns:
        Dict[str, DataFrame]: A dictionary with keys as the table names and values as
        the dataframes.
    """
    dataframes = {
        table_name: read_csv(f"{csv_folder}/{csv_file}")
        for csv_file, table_name in csv_table_mapping.items()
    }

    holidays = get_public_holidays(public_holidays_url, "2017")

    dataframes["public_holidays"] = holidays

    return dataframes
